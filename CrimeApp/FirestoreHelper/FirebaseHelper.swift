//
//  FirebaseHelper.swift
//  CrimeApp
//
//  Created by Xin Wang on 2021/3/18.
//  Copyright © 2021 lucas. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// Helper to access firebase.
class FirestoreHelper {
    static let shared = FirestoreHelper()
    
    let db = Firestore.firestore()
}
