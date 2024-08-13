//
//  UserModel.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/13/24.
//

import Foundation

struct UserModel {
    
    let id = UUID()
    let name: String
    let age: Int
    let gender: GenderType
    
}

enum GenderType {
    case man
    case woman
}
