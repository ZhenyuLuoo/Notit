//
//  AppError.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/19.
//  Copyright © 2021 lucas. All rights reserved.
//

import Foundation

typealias SuccessHandler = (Bool, AppError?)->Void

enum AppError: LocalizedError {
    case dbFailed
    case storageFailed
    case signupFailed(reason: String)
    case signinFailed(reason: String)
    case other(reason: String)

    var errorDescription: String {
        switch self {
        case .dbFailed:
            return "Firestore Error."
        case .storageFailed:
            return "Storage Error."
        case .signinFailed(let reason):
            return "Login failed. \(reason)"
        case .signupFailed(let reason):
            return "Signup failed. \(reason)"
        case .other(let reason):
            return reason
        }
    }
}
