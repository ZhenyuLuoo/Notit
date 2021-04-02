//
//  FirestoreHelper+Group.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/18.
//  Copyright © 2021 lucas. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Group helper
extension FirestoreHelper {
    
    // Create
    func createGroup(name: String, by ownerId: String, completion: @escaping Completion) {
        let model = GroupModel(name: name, ownerId: ownerId, members:[ownerId])
        let docRef = self.db.collection(GroupModel.CollectionName).document()
        
        do {
            try docRef.setData(from: model) { error in
                completion(error)
            }
        } catch let error {
            completion(error)
        }
    }
    
    // Retrieve
    func retrieveGroups(contains memberId: String, completion: @escaping (Result<[GroupModel], Error>)->Void) {
        
        let query = self.db.collection(GroupModel.CollectionName)
            .whereField("members", arrayContains: memberId)
            .order(by: "updateTime", descending: true)
            .limit(to: 200)
        
        query.getDocuments { (querySnapshot, error) in
            if let docs = querySnapshot?.documents {
                
                var groups: [GroupModel] = []
                for doc in docs {
                    if let groupModel = try? doc.data(as: GroupModel.self) {
                        groups.append(groupModel)
                    }
                }
                completion(.success(groups))
            }
            else {
                completion(.failure(AppError.dbFailed))
            }
        }
    }
    
    // Retrieve
    func retrieveGroup(groupId: String, completion: @escaping (Result<GroupModel, Error>)->Void) {
        let docRef = self.db.collection(GroupModel.CollectionName).document(groupId)
        docRef.getDocument {(snapshot, error) in
            if let newModel = try? snapshot?.data(as: GroupModel.self) {
                completion(.success(newModel))
            }
            else {
                completion(.failure(AppError.dbFailed))
            }
        }
    }
    
    // Update
    func updateGroup(groupId: String, addMembers: [String], completion: @escaping Completion) {
        let docRef = self.db.collection(GroupModel.CollectionName).document(groupId)
        
        docRef.updateData(["members": FieldValue.arrayUnion(addMembers)]) { error in
            completion(error)
        }
    }
    
    // Update
    func updateGroup(groupId: String, rmMembers: [String], completion: @escaping Completion) {
        let docRef = self.db.collection(GroupModel.CollectionName).document(groupId)
        docRef.updateData(["members": FieldValue.arrayRemove(rmMembers)]) { error in
            completion(error)
        }
    }
    
    // Update
    func updateGroup(groupId: String, eventCount: Int, completion: @escaping Completion) {
        let docRef = self.db.collection(GroupModel.CollectionName).document(groupId)
        docRef.updateData(["eventCount": eventCount]) { error in
            completion(error)
        }
    }
    
    // Delete
    func delete(groupId: String, completion: @escaping Completion) {
        let docRef = self.db.collection(GroupModel.CollectionName).document(groupId)
        docRef.delete(completion: completion)
    }
}
