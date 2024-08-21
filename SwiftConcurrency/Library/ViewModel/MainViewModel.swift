//
//  MainViewModel.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/13/24.
//

import Foundation
import Combine

struct MainViewModel {
    
    struct Inputs {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewWillAppear: AnyPublisher<Void, Never>
        let didTapFetchButton: AnyPublisher<Void, Never>
        let didTapRightNaviBarButton: AnyPublisher<Void, Never>
        let didTapLeftNaviBarButton: AnyPublisher<Void, Never>
    }
    
    struct Outputs {
        let user: AnyPublisher<UserModel, Never>
        let products: AnyPublisher<[ProductModel], Never>
        let event: AnyPublisher<Void, Never>
    }
    
    private let userRepository: UserRepositoryProtocol
    private let productRepository: ProductRepositoryProtocol
    private let navigator: MainNavigatorProtocol
    
    init(userRepository: UserRepositoryProtocol,
         productRepository: ProductRepositoryProtocol,
         navigator: MainNavigatorProtocol
    ) {
        self.userRepository = userRepository
        self.productRepository = productRepository
        self.navigator = navigator
    }
    
}

extension MainViewModel {
    
    func bind(_ inputs: Inputs) -> Outputs {
        let navigator = self.navigator
        
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
                    Task {
                        do {
                            async let userModel = try await self.userRepository.fetchUser()
                            async let productModels = try await self.productRepository.fetchProduct()
                            
                            let newUserModel = try await userModel
                            let newProductModels = try await productModels
                            userPublisher.send(newUserModel)
                            productSubject.send(newProductModels)
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
                .eraseToAnyPublisher(),
            inputs.didTapRightNaviBarButton
                .map {
                    navigator.toUserInfo()
                }
                .eraseToAnyPublisher(),
            inputs.didTapLeftNaviBarButton
                .map {
                    navigator.toBookLibrary()
                }
                .eraseToAnyPublisher()
        )
            .eraseToAnyPublisher()
        
        return .init(user: userPublisher.eraseToAnyPublisher(),
                     products: productSubject.eraseToAnyPublisher(),
                     event: events)
    }
    
}
