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

enum EntityError: Error {
    case signupFailed(reason: String)
    case signinFailed(reason: String)
    case firebaseError(error: Error)
    
    var localizedDescription: String {
        
        switch self {
        case .signinFailed(let reason):
            return "Signin failed. \(reason)"
        case .signupFailed(let reason):
            return "Signup failed. \(reason)"
        case .firebaseError(let error):
            return error.localizedDescription
        default:
            return ""
        }
    }
    
}

typealias SuccessHandler = (Bool, EntityError?)->Void

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
        let newUser = UserModel(nickname: nickname ?? username, username: username, password: password)
        let docRef = db.collection(UserModel.CollectionName).document(username)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
               let err = EntityError.signupFailed(reason: "\(username) already exists!")
                handler(false, err)
            } else {
                docRef.setData(newUser.toFireDict())
                handler(true, nil)
            }
        }
    }
    
    func signin(username: String, password: String, handler: @escaping SuccessHandler) {
        let docRef = db.collection(UserModel.CollectionName).document(username)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                if let documentData = document.data(),
                   let user = UserModel(fireDict: documentData),
                   user.password == password {
                    self.currentUser = user
                    handler(true, nil)
                }
                else {
                    let err = EntityError.signinFailed(reason: "Wrong username or password!")
                    handler(false, err)
                }
                
            } else {
                let err = EntityError.signinFailed(reason: "\(username) does not exist!")
                handler(false, err)
            }
        }
    }
    
    @discardableResult
    func addCrime(title: String, content: String, image: Data?) -> EventModel? {
        
        guard let me = self.currentUser else {
            return nil
        }
        var event = EventModel(title: title, content: content, ownerId: me.uuid)
        
        if let imgData = image {
            let imageName = "events/\(event.uuid).jpeg"
            let imageRef = self.imageRef(imgName: imageName)
            event.imageName = imageName

            // Upload the file to the path "images/rivers.jpg"
            let meta = StorageMetadata()
            meta.contentType = "image/jpeg"
            imageRef.putData(imgData, metadata: meta) { (metadata, error) in
                
            }
        }
        
        db.collection(EventModel.CollectionName).addDocument(data: event.toFireDict())
        
        return event
    }
    
    @discardableResult
    func addComment(content: String, to event: EventModel) -> CommentModel? {
        
        guard let me = self.currentUser else {
            return nil
        }
        
        let comment = CommentModel(content: content, eventId: event.uuid,
                                   ownerId: me.uuid, ownerName: me.nickname)
        
        db.collection(CommentModel.CollectionName).addDocument(data: comment.toFireDict())
        
        return comment
    }
    
    func delete(event documentId: String) {
        db.collection(EventModel.CollectionName).document(documentId).delete()
    }
    
    func delete(comment documentId: String) {
        db.collection(CommentModel.CollectionName).document(documentId).delete()
    }
    
    func imageRef(imgName: String) -> StorageReference {
        let storageRef = storage.reference()
        let reference = storageRef.child(imgName)
        return reference
    }
}
