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
    }
    
    struct Outputs {
        let event: AnyPublisher<Void, Never>
    }
    
    private let navigator: UserInfoNavigatorProtocol
    
    init(navigator: UserInfoNavigatorProtocol) {
        self.navigator = navigator
    }
    
}

extension UserInfoViewModel {
    
    func bind(_ inputs: Inputs) -> Outputs {
        
        let event = Publishers.MergeMany(
            inputs.viewDidLoad
                .map {
                    print("ViewDidLoad")
                }
                .eraseToAnyPublisher()
        )
            .eraseToAnyPublisher()
        
        return .init(event: event)
    }
    
}
