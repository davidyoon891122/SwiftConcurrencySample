//
//  BookModel.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/21/24.
//

import Foundation

struct BookModel: Identifiable, Hashable {
    
    let id: UUID
    let name: String
    let image: URL?
    let description: String
    let author: String
    
    
    init(id: UUID = UUID(), name: String, image: URL?, description: String, author: String) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.author = author
    }
}

extension BookModel {
    
    static let books: [Self] = [
        .init(name: "일론 머스크",
              image: URL(string: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9791171170418.jpg"),
              description: "천재인가 몽상가인가, 영웅인가 사기꾼인가? 수많은 논란 속에서도 1%의 가능성에 모든 걸 걸며 인류의 미래를 바꾸는 이 시대 최고의 혁신가, 일론 머스크의 모든 것!",
              author: "월터 아이작슨")
            
    ]
    
}
