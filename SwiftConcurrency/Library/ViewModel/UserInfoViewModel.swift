//
//  UserInfoViewModel.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/20/24.
//

import Foundation
import Combine

struct UserInfoViewModel {
    
    struct Inputs {
        let viewDidLoad: AnyPublisher<Void, Never>
        let didTapFetchButton: AnyPublisher<Void, Never>
    }
    
    struct Outputs {
        let movieUrl: AnyPublisher<URL, Never>
        let event: AnyPublisher<Void, Never>
    }
    
    private let navigator: UserInfoNavigatorProtocol
    private let authRepository: AuthRepositoryProtocol
    
    init(navigator: UserInfoNavigatorProtocol,
         authRepository: AuthRepositoryProtocol) {
        self.navigator = navigator
        self.authRepository = authRepository
    }
    
}

extension UserInfoViewModel {
    
    func bind(_ inputs: Inputs) -> Outputs {
        
        let movieUrlSubject: PassthroughSubject<URL, Never> = .init()
        
        let event = Publishers.MergeMany(
            inputs.viewDidLoad
                .map {
                    Task {
                        do {
                            let token = try await authRepository.getBearerToken()
                            print("Token: \(token)")
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .eraseToAnyPublisher(),
            inputs.didTapFetchButton
                .map {
                    movieUrlSubject.send(URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")!)
                }
                .eraseToAnyPublisher()
        )
            .eraseToAnyPublisher()
        
        return .init(movieUrl: movieUrlSubject.eraseToAnyPublisher(), event: event)
    }
    
}
