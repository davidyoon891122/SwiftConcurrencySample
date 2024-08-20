//
//  UserInfoNavigator.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/20/24.
//

import UIKit

protocol UserInfoNavigatorProtocol {
    
    func toUserInfo()
    
}

struct UserInfoNavigator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    
}

extension UserInfoNavigator: UserInfoNavigatorProtocol {
    
    func toUserInfo() {
        let viewModel = UserInfoViewModel(navigator: self)
        let viewController = UserInfoViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
