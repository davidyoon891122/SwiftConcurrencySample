//
//  AuthService.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/20/24.
//

import Foundation

final actor AuthRepository {
    
    private var tokenTask: Task<String, Error>?
    
    func getBearerToken() async throws -> String {
        if self.tokenTask == nil {
            self.tokenTask = Task {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                return "Bearer 000000"
            }
        }
        
        defer { tokenTask = nil }
        
        return try await self.tokenTask!.value
    }
    
}
