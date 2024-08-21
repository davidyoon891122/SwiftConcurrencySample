//
//  BookLibraryViewModel.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/21/24.
//

import Foundation
import Combine

struct BookLibraryViewModel {
    
    struct Inputs {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Outputs {
        let items: AnyPublisher<[BookModel], Never>
        let event: AnyPublisher<Void, Never>
    }
    
    private let navigator: BookLibraryNavigatorProtocol
    private let libraryRepository: LibraryRepositoryProtocol
    
    init(navigator: BookLibraryNavigatorProtocol,
         libraryRepository: LibraryRepositoryProtocol) {
        self.navigator = navigator
        self.libraryRepository = libraryRepository
    }
    
}

extension BookLibraryViewModel {
    
    func bind(_ inputs: Inputs) -> Outputs {
        let navigator = self.navigator
        let libraryRepository = self.libraryRepository
        
        let booksSubject: PassthroughSubject<[BookModel], Never> = .init()
        
        let event = Publishers.MergeMany(
            inputs.viewDidLoad
                .map {
                    print("ViewDidLoad")
                    Task {
                        let books = try await libraryRepository.fetchBooks()
                        print(books)
                        booksSubject.send(books)
                    }
                }
                .eraseToAnyPublisher()
        )
            .eraseToAnyPublisher()
        
        return .init(items: booksSubject.eraseToAnyPublisher(), event: event)
    }
    
}
