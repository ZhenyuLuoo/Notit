//
//  FirestoreHelper.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/18.
//  Copyright © 2021 lucas. All rights reserved.
//

import Foundation
import FirebaseFirestore

let appDB = FirestoreHelper.shared

/// Helper to access firebase.
class FirestoreHelper {
    
    typealias Completion = (Error?)->Void
    
    static let shared = FirestoreHelper()
    let db = Firestore.firestore()
    
    private init() {
        let settings = db.settings
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
}

