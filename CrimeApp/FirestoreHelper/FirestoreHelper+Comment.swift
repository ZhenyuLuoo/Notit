//
//  FirestoreHelper+Comment.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/18.
//  Copyright © 2021 lucas. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// Comment helper
extension FirestoreHelper {
    
    /// Create
    func createComment(content: String, eventId: String, ownerId: String, ownerName: String, completion: @escaping Completion) {
        
        let model = CommentModel(content: content, ownerId: ownerId,
                                 ownerName: ownerName, eventId: eventId)
        
        let docRef = self.db.collection(CommentModel.CollectionName).document()
        
        do {
            try docRef.setData(from: model) { error in
                completion(error)
            }
        } catch let error {
            completion(error)
        }
    }
    
    /// Delete
    func delete(commentId: String, completion: @escaping Completion) {
        let docRef = self.db.collection(CommentModel.CollectionName).document(commentId)
        docRef.delete { (error) in
            completion(error)
        }
    }
}
