//
//  ProductModel.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/19/24.
//

import Foundation

struct ProductModel: Identifiable, Hashable {
    
    let id: UUID
    let image: URL?
    let name: String
    let brand: String
    let description: String
    let price: Double
    let isDiscounted: Bool
    let discountPercent: Double?
    
    init(id: UUID = UUID(), image: URL?, name: String, brand: String, description: String, price: Double, isDiscounted: Bool = false , discountPercent: Double? = nil) {
        self.id = id
        self.image = image
        self.name = name
        self.brand = brand
        self.description = description
        self.price = price
        self.isDiscounted = isDiscounted
        self.discountPercent = discountPercent
    }
    
}

extension ProductModel {
    
    static let fakes: [Self] = [
        .init(image: URL(string: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/a259ee86-2502-461b-8b72-1d833e03958d/W+AIR+FORCE+1+%2707+PRM.png"), name: "Air Force 1", brand: "NIKE", description: "NIKE ARI FORCE 1 07", price: 120000, isDiscounted: true, discountPercent: 10),
        .init(image: URL(string: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/b3fe91f5-2696-46c6-ab05-5fdef7015a05/WMNS+AIR+MAX+97.png"), name: "Air Max 97", brand: "NIKE", description: "NIKE AIR MAX 97", price: 175000)
    ]
    
}
