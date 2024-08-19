//
//  ProductRepository.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/19/24.
//

import Foundation

protocol ProductRepositoryProtocol {
    
    func fetchProduct() async throws -> [ProductModel]
    
}

final class ProductRepository {
    
    
    
}

extension ProductRepository: ProductRepositoryProtocol {
    
    func fetchProduct() async throws -> [ProductModel] {
        try await Task.sleep(nanoseconds: 5_000_000_000)
        
        return ProductModel.fakes
    }
    
}
