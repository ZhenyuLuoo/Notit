//
//  Models.swift
//  CrimeApp
//
//  Created by lucas on 2021/2/25.
//  Copyright © 2021 lucas. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct EventModel {
    static let CollectionName = "events"
    
    var uuid: String = UUID().uuidString
    var createTime: Date = Date()
    var updateTime: Date = Date()
    var title: String
    var content: String
    var ownerId: String
    var imageName: String = ""
    var comments: [CommentModel] = []
}

struct CommentModel {
    static let CollectionName = "comments"
    
    var uuid: String = UUID().uuidString
    var createTime: Date = Date()
    var updateTime: Date = Date()
    var content: String
    var eventId: String
    var ownerId: String
    var ownerName: String
}

struct UserModel {
    static let CollectionName = "users"
    
    var uuid: String = UUID().uuidString
    var createTime: Date = Date()
    var updateTime: Date = Date()
    var nickname: String
    var username: String
    var password: String
}

extension EventModel: FireCodable {
    init?(fireDict: [String: Any]) {
        guard let uuid = fireDict["uuid"] as? String,
              let createTime = fireDict["createTime"] as? Timestamp,
              let updateTime = fireDict["updateTime"] as? Timestamp,
              let title = fireDict["title"] as? String,
              let content = fireDict["content"] as? String,
              let ownerId = fireDict["ownerId"] as? String,
              let imageName = fireDict["imageName"] as? String
        else { return nil }
        
        self.init(uuid: uuid, createTime: createTime.dateValue(),
                  updateTime: updateTime.dateValue(), title: title,
                  content: content, ownerId: ownerId,
                  imageName: imageName)
    }
    
    func toFireDict() -> [String : Any] {
        return ["uuid": uuid,
                "createTime": Timestamp(date: createTime),
                "updateTime": Timestamp(date: updateTime),
                "title": title,
                "content": content,
                "ownerId": ownerId,
                "imageName": imageName]
    }
}

extension CommentModel: FireCodable {

    init?(fireDict: [String: Any]) {
        guard let uuid = fireDict["uuid"] as? String,
              let createTime = fireDict["createTime"] as? Timestamp,
              let updateTime = fireDict["updateTime"] as? Timestamp,
              let content = fireDict["content"] as? String,
              let eventId = fireDict["eventId"] as? String,
              let ownerId = fireDict["ownerId"] as? String,
              let ownerName = fireDict["ownerName"] as? String
        else { return nil }
        
        self.init(uuid: uuid, createTime: createTime.dateValue(),
                  updateTime: updateTime.dateValue(),
                  content: content, eventId: eventId,
                  ownerId: ownerId, ownerName: ownerName)
    }
    
    func toFireDict() -> [String : Any] {
        return ["uuid": uuid,
                "createTime": Timestamp(date: createTime),
                "updateTime": Timestamp(date: updateTime),
                "content": content,
                "eventId": eventId,
                "ownerId": ownerId,
                "ownerName": ownerName]
    }
}

extension UserModel: FireCodable {
    
    init?(fireDict: [String: Any]) {
        guard let uuid = fireDict["uuid"] as? String,
              let createTime = fireDict["createTime"] as? Timestamp,
              let updateTime = fireDict["updateTime"] as? Timestamp,
              let nickname = fireDict["nickname"] as? String,
              let username = fireDict["username"] as? String,
              let password = fireDict["password"] as? String
        else { return nil }
        
        
        self.init(uuid: uuid, createTime: createTime.dateValue(),
                  updateTime: updateTime.dateValue(), nickname: nickname,
                  username: username, password: password)
    }
    
    func toFireDict() -> [String : Any] {
        return ["uuid": uuid,
                "createTime": Timestamp(date: createTime),
                "updateTime": Timestamp(date: updateTime),
                "nickname": nickname,
                "username": username,
                "password": password]
    }
}
