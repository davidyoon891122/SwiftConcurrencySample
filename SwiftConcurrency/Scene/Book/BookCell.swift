//
//  BookCell.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/21/24.
//

import UIKit
import SnapKit
import Kingfisher

final class BookCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: BookCell.self)
    
    private lazy var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        
        imageView.kf.setImage(with: URL(string: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9791171170418.jpg"))
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "일론 머스크"
        label.font = .boldSystemFont(ofSize: 22.0)
        label.textColor = .label
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "월터 아이작슨"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 18.0)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "천재인가 몽상가인가, 영웅인가 사기꾼인가? 수많은 논란 속에서도 1%의 가능성에 모든 걸 걸며 인류의 미래를 바꾸는 이 시대 최고의 혁신가, 일론 머스크의 모든 것!"
        label.textColor = .label
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        [
            self.bookImageView,
            self.titleLabel,
            self.descriptionLabel,
            self.authorLabel
        ].forEach { view.addSubview($0) }
        
        self.bookImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.0)
            $0.leading.equalToSuperview().offset(16.0)
            $0.width.height.equalTo(80.0)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.0)
            $0.leading.equalTo(self.bookImageView.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview().offset(-16.0)
        }
        
        self.descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(16.0)
            $0.leading.equalTo(self.titleLabel)
            $0.trailing.equalTo(self.titleLabel)
        }
        
        self.authorLabel.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(16.0)
            $0.trailing.equalToSuperview().offset(-16.0)
            $0.bottom.equalToSuperview().offset(-16.0)
        }
        
        return view
    }()
    
    
    func setupData(data: BookModel) {
        self.titleLabel.text = data.name
        self.bookImageView.kf.setImage(with: data.image)
        self.descriptionLabel.text = data.description
        self.authorLabel.text = data.author
        self.setupViews()
    }
    
}

private extension BookCell {
    
    func setupViews() {
        self.contentView.addSubview(self.containerView)
        
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

#Preview {
    let cell = BookCell()
    cell.snp.makeConstraints {
        $0.height.equalTo(300)
    }
    cell.setupData(data: BookModel.books[0])
    return cell
}
