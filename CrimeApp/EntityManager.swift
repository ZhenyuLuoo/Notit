//
//  EntityManager.swift
//  CrimeApp
//
//  Created by lucas on 2020/12/3.
//  Copyright © 2020 lucas. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Firebase
import FirebaseFirestore

let appMgr = EntityManager.shared

// Manage Core Data eneities.
class EntityManager {
    // Singleton
    static let shared: EntityManager = EntityManager()
    private init() {
        let settings = db.settings
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var currentUser: UserModel?
    
    func signup(username: String, password: String, nickname: String?, handler: @escaping SuccessHandler) {
        
        appDB.createUser(username: username, password: password, nickname: username) { (error) in
            if let err = error {
                handler(false, err as? AppError)
            }
            else {
                handler(true, nil)
            }
        }
    }
    
    func signin(username: String, password: String, handler: @escaping SuccessHandler) {
        appDB.retrieveUser(username: username, password: password) { [weak self] (result) in
            switch result {
            case .success(let user):
                self?.currentUser = user
                handler(true, nil)
                
            case .failure(let error):
                if let err = error as? AppError {
                    handler(false, err)
                }
                else {
                    let err = AppError.signinFailed(reason: "Login failed!")
                    handler(false, err)
                }
            }
        }
    }
    
    func addCrime(title: String, content: String, image: Data?, groupId: String,
                  handler: @escaping SuccessHandler) {
        
        guard let me = self.currentUser?.uuid else {
            handler(false, AppError.other(reason: "Not Login."))
            return
        }
        
        
        if let imgData = image {
            let imageName = "events/\(UUID().uuidString).jpeg"
            appStorage.uploadImage(data: imgData, imgName: imageName) { (success, error) in
                
                // whatever succeed or not.
                appDB.createEvent(title: title, content: content, attachment: imageName, in: groupId, by: me) { (error) in
                    if let _ = error {
                        handler(false, .other(reason: "Add event failed."))
                    }
                    else {
                        handler(true, nil)
                    }
                }
            }
        }
        else {
            appDB.createEvent(title: title, content: content, attachment: nil, in: groupId, by: me) { (error) in
                if let _ = error {
                    handler(false, .other(reason: "Add event failed."))
                }
                else {
                    handler(true, nil)
                }
            }
        }
    }
    
    func addComment(content: String, to event: EventModel, handler: @escaping SuccessHandler) {
        
        guard let me = self.currentUser?.uuid, let name = self.currentUser?.nickname else {
            handler(false, AppError.other(reason: "Not Login."))
            return
        }
        
        guard let eventId = event.uuid else {
            handler(false, AppError.other(reason: "Event Not Found."))
            return
        }
        
        appDB.createComment(content: content, eventId: eventId, ownerId: me, ownerName: name) { (error) in
            
            if let err = error {
                handler(false, .dbFailed)
            }
            else {
                handler(true, nil)
            }
        }
    }
    
    func delete(event eventId: String, handler: @escaping SuccessHandler) {
        db.collection(EventModel.CollectionName).document(eventId).delete() { error in
            if let err = error {
                handler(false, .dbFailed)
            }
            else {
                handler(true, nil)
            }
        }
    }
    
    func delete(comment commentId: String, handler: @escaping SuccessHandler) {
        db.collection(CommentModel.CollectionName).document(commentId).delete() { error in
            if let err = error {
                handler(false, .dbFailed)
            }
            else {
                handler(true, nil)
            }
        }
    }

}
