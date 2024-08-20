//
//  UserInfoViewController.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/20/24.
//

import UIKit
import Combine
import SnapKit
import CombineCocoa

final class UserInfoViewController: UIViewController {
    
    private let viewModel: UserInfoViewModel
    
    private let viewDidLoadSubject: PassthroughSubject<Void, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: UserInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var fetchButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Fetch", for: .normal)
        button.setTitleColor(.label, for: .normal)
        
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        button.layer.cornerRadius = 4.0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
}

private extension UserInfoViewController {
    
    func setupViews() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = String(describing: UserInfoViewController.self)
    }
    
    func bindViewModel() {
        let outputs = self.viewModel.bind(.init(viewDidLoad: self.viewDidLoadSubject.eraseToAnyPublisher()))
        
        [
            outputs.event
                .sink(receiveValue: {
                    
                })
        ].forEach { self.cancellables.insert($0) }
    }
    
}


#Preview {
    UINavigationController(rootViewController: UserInfoViewController(viewModel: UserInfoViewModel(navigator: UserInfoNavigator(navigationController: UINavigationController()))))
}
