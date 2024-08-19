//
//  ViewModel.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/13/24.
//

import Foundation
import Combine

struct ViewModel {
    
    struct Inputs {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewWillAppear: AnyPublisher<Void, Never>
        let didTapFetchButton: AnyPublisher<Void, Never>
    }
    
    struct Outputs {
        let user: AnyPublisher<UserModel, Never>
        let products: AnyPublisher<[ProductModel], Never>
        let event: AnyPublisher<Void, Never>
    }
    
    private let userRepository: UserRepositoryProtocol
    private let productRepository: ProductRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol,
         productRepository: ProductRepositoryProtocol
    ) {
        self.userRepository = userRepository
        self.productRepository = productRepository
    }
    
}

extension ViewModel {
    
    func bind(_ inputs: Inputs) -> Outputs {
        
        let userPublisher: PassthroughSubject<UserModel, Never> = .init()
        let productSubject: PassthroughSubject<[ProductModel], Never> = .init()
        
        let events = Publishers.MergeMany(
            inputs.viewDidLoad
                .map {
                    print("ViewDidLoad")
                }
                .eraseToAnyPublisher(),
            inputs.viewWillAppear
                .map {
                    print("ViewWillAppear")
                    Task {
                        do {
                            let userModel = try await self.userRepository.fetchUser()
                            let productModels = try await self.productRepository.fetchProduct()
                            userPublisher.send(userModel)
                            productSubject.send(productModels)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .eraseToAnyPublisher(),
            inputs.didTapFetchButton
                .map {
                    Task {
                        do {
                            let userModel = try await self.userRepository.fetchUser()
                            
                            let productModels = try await self.productRepository.fetchProduct()
                            
                            userPublisher.send(userModel)
                            productSubject.send(productModels)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .eraseToAnyPublisher()
        )
            .eraseToAnyPublisher()
        
        return .init(user: userPublisher.eraseToAnyPublisher(),
                     products: productSubject.eraseToAnyPublisher(),
                     event: events)
    }
    
}
