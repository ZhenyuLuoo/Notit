//
//  Models.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/19.
//  Copyright © 2021 lucas. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

let ModelPrefix = "v2_"

/// User
struct UserModel: Codable {
    static let CollectionName = ModelPrefix + "users"

    // - base fields
    @DocumentID
    var uuid: String?
    
    @ServerTimestamp
    var updateTime: Date?
    
    @ServerTimestamp
    var createTime: Date?
    
    // - fields
    var username: String
    var password: String
    var nickname: String
    var avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case createTime
        case updateTime
        case username
        case password
        case nickname
        case avatar
    }
}

/// Group
class GroupModel: Codable {
    static let CollectionName = ModelPrefix + "groups"

    // - base fields
    @DocumentID
    var uuid: String?
    
    @ServerTimestamp
    var updateTime: Date?
    
    @ServerTimestamp
    var createTime: Date?
    
    // - fields
    var name: String
    var ownerId: String
    var eventCount: Int = 0
    var members: Set<String> = []

    // - others
    
    var memberCount: Int {
        return members.count
    }
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case createTime
        case updateTime
        case name
        case ownerId
        case eventCount
        case members
    }
    
    init(name: String, ownerId: String, eventCount: Int = 0, members: Set<String> = []) {
        self.name = name
        self.ownerId = ownerId
        self.eventCount = eventCount
        self.members = members
    }
}

/// Event
struct EventModel: Codable {
    static let CollectionName = ModelPrefix + "events"
    
    // - base fields
    @DocumentID
    var uuid: String?
    
    @ServerTimestamp
    var updateTime: Date?
    
    @ServerTimestamp
    var createTime: Date?
    
    // - fields
    var title: String
    var content: String
    var ownerId: String
    var groupId: String
    var attachment: String?
    var commentCount: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case createTime
        case updateTime
        case title
        case content
        case ownerId
        case groupId
        case attachment
        case commentCount
    }
}

/// Comment
struct CommentModel: Codable {
    static let CollectionName = ModelPrefix + "comments"
    
    // - base fields
    @DocumentID
    var uuid: String?
    
    @ServerTimestamp
    var updateTime: Date?
    
    @ServerTimestamp
    var createTime: Date?
    
    // - fields
    var content: String
    var ownerId: String
    var ownerName: String
    var eventId: String
    
    // - others
    var owner: UserModel?
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case createTime
        case updateTime
        case content
        case ownerId
        case ownerName
        case eventId
    }
}
