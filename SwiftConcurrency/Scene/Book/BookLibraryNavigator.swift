//
//  BookLibraryNavigator.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/21/24.
//

import UIKit

protocol BookLibraryNavigatorProtocol {
    
    func toBookLibrary()
    
}

struct BookLibraryNavigator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
}

extension BookLibraryNavigator: BookLibraryNavigatorProtocol {
    
    func toBookLibrary() {
        let viewModel = BookLibraryViewModel(navigator: self,
                                             libraryRepository: LibraryRepository())
        
        let viewController = BookLibraryViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController,
                                                      animated: true)
    }
    
}
