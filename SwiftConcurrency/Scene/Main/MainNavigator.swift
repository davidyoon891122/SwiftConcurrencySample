//
//  MainNavigator.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/20/24.
//

import UIKit

protocol MainNavigatorProtocol {
    
    func toMain()
    func toUserInfo()
    func toBookLibrary()
    
}

struct MainNavigator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
}

extension MainNavigator: MainNavigatorProtocol {
    
    func toMain() {
        let viewModel = MainViewModel(userRepository: UserRepository(),
                                      productRepository: ProductRepository(),
                                      navigator: self)
        let viewController = MainViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func toUserInfo() {
        let navigator = UserInfoNavigator(navigationController: self.navigationController)
        navigator.toUserInfo()
    }
    
    func toBookLibrary() {
        let navigator = BookLibraryNavigator(navigationController: self.navigationController)
        navigator.toBookLibrary()
    }
    
}
