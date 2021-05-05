//
//  FirestoreHelper+User.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/18.
//  Copyright © 2021 lucas. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// User helper
extension FirestoreHelper {
    
    /// Create
    func createUser(username: String, password: String, nickname: String, avatar: String? = nil,
                    completion: @escaping Completion) {
        
        let model = UserModel(username: username, password: password, nickname: nickname, avatar: avatar)
        
        let docRef = self.db.collection(UserModel.CollectionName).document(username)
        docRef.getDocument { (snapshot, error) in
            if let ss = snapshot, ss.exists {
                completion(AppError.signupFailed(reason: "User exsits."))
            }
            else {
                do {
                    try docRef.setData(from: model) { error in
                        completion(error)
                    }
                } catch let error {
                    completion(error)
                }
            }
        }
    }
    
    /// Retrieve
    func retrieveUser(username: String, password: String, completion: @escaping (Result<UserModel, Error>)->Void) {
        let docRef = self.db.collection(UserModel.CollectionName).document(username)
        
        docRef.getDocument { (snapshot, error) in
            if error != nil {
                completion(.failure(AppError.dbFailed))
            }
            else if let userModel = try? snapshot?.data(as: UserModel.self) {
                
                if userModel.password == password {
                    completion(.success(userModel))
                }
                else {
                    completion(.failure(AppError.signinFailed(reason: "Wrong password or username.")))
                }
            }
            else {
                completion(.failure(AppError.signinFailed(reason: "User does not exist.")))
            }
        }
    }
    
    /// Retrieve
    func retrieveUsers(userIdList: [String], completion: @escaping (Result<[UserModel], Error>)->Void) {
        let query = self.db.collection(UserModel.CollectionName)
            .whereField("username", in: userIdList)
            .limit(to: 200)
        
        query.getDocuments { (querySnapshot, error) in
            if let docs = querySnapshot?.documents {
                var models: [UserModel] = []
                for doc in docs {
                    if let model = try? doc.data(as: UserModel.self) {
                        models.append(model)
                    }
                }
                completion(.success(models))
            }
            else {
                completion(.failure(AppError.dbFailed))
            }
        }
    }
    
    /// Retrieve
    func retrieveUsers(completion: @escaping (Result<[UserModel], Error>)->Void) {
        let query = self.db.collection(UserModel.CollectionName)
            .limit(to: 200)
        
        query.getDocuments { (querySnapshot, error) in
            if let docs = querySnapshot?.documents {
                var models: [UserModel] = []
                for doc in docs {
                    if let model = try? doc.data(as: UserModel.self) {
                        models.append(model)
                    }
                }
                completion(.success(models))
            }
            else {
                completion(.failure(AppError.dbFailed))
            }
        }
    }
    
    /// Retrieve
    func retrieveMembers(of groupModel: GroupModel, completion: @escaping (Result<[UserModel], Error>)->Void) {
        
        guard groupModel.members.count > 0 else {
            completion(.success([]))
            return
        }
        
        let query = self.db.collection(UserModel.CollectionName)
            .whereField("username", in: Array(groupModel.members))
            .limit(to: 200)
        
        query.getDocuments { (querySnapshot, error) in
            if let docs = querySnapshot?.documents {
                
                var members: [UserModel] = []
                for doc in docs {
                    if let model = try? doc.data(as: UserModel.self) {
                        members.append(model)
                    }
                }
                completion(.success(members))
            }
            else {
                completion(.failure(AppError.dbFailed))
            }
        }
    }
    
    /// Update
    func updateUser(_ userId:String, nickname: String, completion: @escaping Completion) {
        let docRef = self.db.collection(UserModel.CollectionName).document(userId)
        docRef.updateData(["nickname": nickname]) { error in
            completion(error)
        }
    }
    
    /// Update
    func updateUser(_ userId:String, avatar: String, completion: @escaping Completion) {
        let docRef = self.db.collection(UserModel.CollectionName).document(userId)
        docRef.updateData(["avatar": avatar]) { error in
            completion(error)
        }
    }
}
