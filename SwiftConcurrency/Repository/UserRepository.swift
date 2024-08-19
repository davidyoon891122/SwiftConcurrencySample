//
//  UserRepository.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/13/24.
//

import Foundation

protocol UserRepositoryProtocol {
    
    func fetchUser() async throws -> UserModel
    
}

final class UserRepository {
    
}

extension UserRepository: UserRepositoryProtocol {
    
    func fetchUser() async throws -> UserModel {
        try await Task.sleep(nanoseconds: 1_000_000_000)
            
        return UserModel.init(name: "David", age: 34, gender: .man)
    }
    
}
