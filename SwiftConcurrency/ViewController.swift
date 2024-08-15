//
//  ViewController.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/13/24.
//

import UIKit
import Combine
import CombineCocoa
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
        imageView.image = UIImage(systemName: "arrowshape.up.fill")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var userProfileView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 4.0
        
        [
            self.userNameLabel,
            self.userAgeLabel,
            self.genderImageView
        ].forEach { view.addSubview($0) }
        
        self.userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.0)
            $0.leading.equalToSuperview().offset(16.0)
        }
        
        self.genderImageView.snp.makeConstraints {
            $0.width.height.equalTo(20.0)
            $0.leading.equalTo(self.userNameLabel.snp.trailing).offset(16.0)
            $0.centerY.equalTo(self.userNameLabel)
        }
        
        self.userAgeLabel.snp.makeConstraints {
            $0.top.equalTo(self.userNameLabel.snp.bottom).offset(8.0)
            $0.leading.trailing.equalTo(self.userNameLabel)
            $0.bottom.equalToSuperview().offset(-16.0)
        }
        
        return view
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
        self.bindViewModel()
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
            self.userProfileView,
            self.fetchButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.userProfileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16.0)
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
            viewWillAppear: self.viewWillAppearPublisher.eraseToAnyPublisher(),
            didTapFetchButton: self.fetchButton.tapPublisher
        ))
        
        [
            outputs.event
                .sink(receiveValue: { _ in }),
            outputs.user
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] user in
                    self?.setUserData(user: user)
                })
        ].forEach { self.cancellables.insert($0) }
    }
 
    func setUserData(user: UserModel) {
        self.userNameLabel.text = user.name
        self.userAgeLabel.text = "\(user.age) years"
        self.genderImageView.image = user.genderImage
    }
    
}

#Preview {
    ViewController(viewModel: ViewModel(repository: UserRepository()))
}
