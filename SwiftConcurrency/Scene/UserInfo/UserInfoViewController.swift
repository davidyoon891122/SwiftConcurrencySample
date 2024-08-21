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
import AVKit

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
    
    private lazy var playerViewController: AVPlayerViewController = {
        let player = AVPlayerViewController()
        
        return player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.bindViewModel()
        
        self.viewDidLoadSubject.send()
    }
    
}

private extension UserInfoViewController {
    
    func setupViews() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = String(describing: UserInfoViewController.self)
        
        [
            self.fetchButton
        ].forEach { self.view.addSubview($0) }
        
        self.fetchButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16.0)
            $0.leading.equalToSuperview().offset(16.0)
            $0.height.equalTo(40.0)
            $0.width.equalTo(80.0)
        }
    }
    
    func setupPlayer(url: URL) {
        self.playerViewController.removeFromParent()
        
        self.addChild(self.playerViewController)
        
        self.view.addSubview(self.playerViewController.view)
        
        self.playerViewController.view.snp.makeConstraints {
            $0.top.equalTo(self.fetchButton.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.playerViewController.didMove(toParent: self)
        
        self.playerViewController.player = AVPlayer(url: url)
        self.playerViewController.player?.play()
        
    }
    
    func bindViewModel() {
        let outputs = self.viewModel.bind(.init(
            viewDidLoad: self.viewDidLoadSubject.eraseToAnyPublisher(),
            didTapFetchButton: self.fetchButton.tapPublisher
        ))
        
        [
            outputs.event
                .sink(receiveValue: { _ in }),
            outputs.movieUrl
                .sink(receiveValue: { [weak self] url in
                    self?.setupPlayer(url: url)
                })
        ].forEach { self.cancellables.insert($0) }
    }
    
}


#Preview {
    UINavigationController(rootViewController: UserInfoViewController(viewModel: UserInfoViewModel(navigator: UserInfoNavigator(navigationController: UINavigationController()), authRepository: AuthRepository())))
}
