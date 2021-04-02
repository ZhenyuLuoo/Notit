//
//  FirestoreHelper+Event.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/18.
//  Copyright © 2021 lucas. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Event helper
extension FirestoreHelper {
    
    /// Create
    func createEvent(title: String, content: String, attachment: String? = nil,
                     in groupId: String, by ownerId: String,
                     completion: @escaping Completion) {
        
        let model = EventModel(title: title, content: content, ownerId: ownerId,
                               groupId: groupId, attachment: attachment)
        
        let docRef = self.db.collection(EventModel.CollectionName).document()
        
        do {
            try docRef.setData(from: model) { error in
                completion(error)
            }
        } catch let error {
            completion(error)
        }
    }
    
    // Retrieve events.
    func retrieveEvents(groupId: String, completion: @escaping (Result<[EventModel], Error>)->Void) {
        
        let query = self.db.collection(EventModel.CollectionName)
            .whereField("groupId", isEqualTo: groupId)
            .order(by: "updateTime", descending: true)
            .limit(to: 200)
        
        query.getDocuments { (querySnapshot, error) in
            if let docs = querySnapshot?.documents {
                
                var events: [EventModel] = []
                for doc in docs {
                    if let model = try? doc.data(as: EventModel.self) {
                        events.append(model)
                    }
                }
                
                completion(.success(events))
            }
            else {
                completion(.failure(AppError.dbFailed))
            }
        }
    }
    
    /// Update
    func updateEvent(_ eventId:String, attachment: String, completion: @escaping Completion) {
        let docRef = self.db.collection(EventModel.CollectionName).document(eventId)
        docRef.updateData(["attachment": attachment]) { error in
            completion(error)
        }
    }
    
    /// Delete
    func delete(eventId: String, groupId: String, completion: @escaping Completion) {
        let docRef = self.db.collection(EventModel.CollectionName).document(eventId)
        docRef.delete { (error) in
            completion(error)
        }
    }
}
