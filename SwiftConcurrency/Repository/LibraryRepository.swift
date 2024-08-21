//
//  LibraryRepository.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/21/24.
//

import Foundation

protocol LibraryRepositoryProtocol {
    
    func fetchBooks() async throws -> [BookModel]
    
}

final class LibraryRepository {
    
}

extension LibraryRepository: LibraryRepositoryProtocol {
    
    func fetchBooks() async throws -> [BookModel] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return BookModel.books
    }
    
}
