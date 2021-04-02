//
//  StorageHelper.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/18.
//  Copyright © 2021 lucas. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

let appStorage = StorageHelper.shared

class StorageHelper {
    static let shared = StorageHelper()
    let storage = Storage.storage()
    
    private init() {}
    
    func imageRef(imgName: String) -> StorageReference {
        let storageRef = storage.reference()
        let reference = storageRef.child(imgName)
        return reference
    }
    
    func uploadImage(data: Data, imgName: String,
                     mimeType: String = "image/jpeg", completion: @escaping SuccessHandler) {
        
        // Upload the file to the path "images/rivers.jpg"
        let meta = StorageMetadata()
        meta.contentType = mimeType
        
        let imageRef = appStorage.imageRef(imgName: imgName)
        imageRef.putData(data, metadata: meta) { [weak self] (metadata, error) in
            if let err = error {
                completion(false, AppError.storageFailed)
            }
            else {
                completion(true, nil)
            }
        }
    }
}
