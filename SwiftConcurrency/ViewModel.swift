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
        let event: AnyPublisher<Void, Never>
    }
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
}

extension ViewModel {
    
    func bind(_ inputs: Inputs) -> Outputs {
        
        let userPublisher: PassthroughSubject<UserModel, Never> = .init()
        
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
                            let userModel = try await self.repository.fetchUser()
                            userPublisher.send(userModel)
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
                            let userModel = try await self.repository.fetchUser()
                            userPublisher.send(userModel)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .eraseToAnyPublisher()
        )
            .eraseToAnyPublisher()
        
        return .init(user: userPublisher.eraseToAnyPublisher(), event: events)
    }
    
}
