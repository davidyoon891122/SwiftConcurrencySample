//
//  BookLibraryViewController.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/21/24.
//

import UIKit
import Combine
import SnapKit

final class BookLibraryViewController: UIViewController {
    
    private let viewDidLoadSubject: PassthroughSubject<Void, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: BookLibraryViewModel
    
    init(viewModel: BookLibraryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = self.createLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.identifier)
        
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, BookModel> = {
        .init(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as? BookCell else { return UICollectionViewCell() }
            cell.setupData(data: item)
            
            return cell
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupNavigationBar()
        self.bindViewModel()
        
        self.viewDidLoadSubject.send()
    }
    
}

private extension BookLibraryViewController {
    
    func setupViews() {
        self.view.backgroundColor = .systemBackground
        [
            self.collectionView
        ].forEach { self.view.addSubview($0) }
        
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "BookLibrary"
    }
    
    func bindViewModel() {
        let outputs = self.viewModel.bind(.init(viewDidLoad: self.viewDidLoadSubject.eraseToAnyPublisher()))
        
        [
            outputs.event
                .sink(receiveValue: { _ in }),
            outputs.items
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] books in
                    self?.applySnapshot(data: books)
                })
        ].forEach { self.cancellables.insert($0) }
        
        
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        .init(sectionProvider: { section, layoutEnvironment in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500.0)))
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500.0)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        })
    }
    
    func applySnapshot(data: [BookModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, BookModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(data, toSection: 0)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

#Preview {
    
    let navigationController = UINavigationController()
    let viewController = BookLibraryViewController(viewModel: BookLibraryViewModel(navigator: BookLibraryNavigator(navigationController: navigationController), libraryRepository: LibraryRepository()))
    
    navigationController.pushViewController(viewController, animated: true)
    
    return navigationController
}
