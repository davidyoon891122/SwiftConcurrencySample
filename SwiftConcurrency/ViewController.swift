//
//  ViewController.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/13/24.
//

import UIKit
import Combine
import SnapKit

class ViewController: UIViewController {
    
    private let viewModel: ViewModel
    private let viewDidLoadPublisher: PassthroughSubject<Void, Never> = .init()
    private let viewWillAppearPublisher: PassthroughSubject<Void, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "----"
        label.textColor = .label
        
        return label
    }()
    
    private lazy var userAgeLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textColor = .label
        
        return label
    }()
    
    private lazy var genderImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var fetchButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        button.layer.cornerRadius = 4.0
        
        button.setTitle("Fetch", for: .normal)
        button.setTitleColor(.label, for: .normal)
        
        return button
    }()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.viewDidLoadPublisher.send()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearPublisher.send()
    }


}

private extension ViewController {
    
    func setupViews() {
        self.view.backgroundColor = .systemBackground
        [
            self.fetchButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.fetchButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(80.0)
            $0.height.equalTo(40.0)
        }
    }
    
    func bindViewModel() {
        let outputs = self.viewModel.bind(.init(
            viewDidLoad: self.viewDidLoadPublisher.eraseToAnyPublisher(),
            viewWillAppear: self.viewWillAppearPublisher.eraseToAnyPublisher()
        ))
        
        [
            outputs.event
                .sink(receiveValue: { _ in }),
            outputs.user
                .sink(receiveValue: { user in
                    
                })
        ].forEach { self.cancellables.insert($0) }
    }
    
}

#Preview {
    ViewController(viewModel: ViewModel(repository: UserRepository()))
}
