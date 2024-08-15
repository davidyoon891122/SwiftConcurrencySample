//
//  UserModel.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/13/24.
//

import UIKit

struct UserModel {
    
    let id = UUID()
    let name: String
    let age: Int
    let gender: GenderType
    
}

extension UserModel {
    
    var genderImage: UIImage? {
        switch self.gender {
        case .man:
            UIImage(systemName: "arrowshape.up.fill")
        case .woman:
            UIImage(systemName: "arrowshape.down.fill")!
        }
    }
    
}

enum GenderType {
    case man
    case woman
}
