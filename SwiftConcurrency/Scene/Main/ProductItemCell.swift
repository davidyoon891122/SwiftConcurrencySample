//
//  ProductItemCell.swift
//  SwiftConcurrency
//
//  Created by Davidyoon on 8/19/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ProductItemCell: UICollectionViewCell {
    
    static let identifier = String(describing: ProductItemCell.self)
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        
        imageView.kf.setImage(with: URL(string: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/b3fe91f5-2696-46c6-ab05-5fdef7015a05/WMNS+AIR+MAX+97.png"))
        
        return imageView
    }()
    
    private lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.text = "[----]"
        label.font = .boldSystemFont(ofSize: 20.0)
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "----"
        label.font = .systemFont(ofSize: 18.0)
        label.textColor = .label
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "--------------------"
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18.0)
        label.textColor = .black
        label.text = "---,--- ￦"
        
        return label
    }()
    
    private lazy var priceDiscountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16.0)
        label.textColor = .red
        label.text = "-- %"
        
        
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemBackground
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 4.0
        
        [
            self.productImageView,
            self.brandLabel,
            self.titleLabel,
            self.descriptionLabel,
            self.priceLabel,
            self.priceDiscountLabel
        ].forEach { view.addSubview($0) }
        
        self.productImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.0)
            $0.leading.equalToSuperview().offset(16.0)
            $0.width.height.equalTo(80.0)
        }
        
        self.brandLabel.snp.makeConstraints {
            $0.top.equalTo(self.productImageView)
            $0.leading.equalTo(self.productImageView.snp.trailing).offset(16.0)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.brandLabel)
            $0.leading.equalTo(self.brandLabel.snp.trailing).offset(8.0)
            $0.trailing.equalToSuperview().offset(-16.0)
        }
        
        self.descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.brandLabel.snp.bottom).offset(16.0)
            $0.leading.equalTo(self.productImageView.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview().offset(-16.0)
        }
        
        self.priceLabel.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(16.0)
            $0.trailing.equalTo(self.priceDiscountLabel.snp.leading).offset(-16.0)
            $0.bottom.equalToSuperview().offset(-16.0)
        }
        
        self.priceDiscountLabel.snp.makeConstraints {
            
            $0.leading.equalTo(self.priceLabel.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview().offset(-16.0)
            $0.centerY.equalTo(self.priceLabel)
        }
        
        return view
    }()
    
    func setData(data: ProductModel) {
        self.productImageView.kf.setImage(with: data.image)
        self.titleLabel.text = data.name
        self.brandLabel.text = data.brand
        self.descriptionLabel.text = data.description
        self.priceLabel.text = "\(data.price) ￦"
        self.priceDiscountLabel.text = "\(data.discountPercent ?? 0)%"
        
        self.setupViews()
    }
    
}

private extension ProductItemCell {
    
    func setupViews() {
        self.contentView.addSubview(self.containerView)
        
        self.containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
    }
    
}

#Preview {
    let itemCell = ProductItemCell()
    itemCell.setData(data: ProductModel.fakes[0])
    
    itemCell.snp.makeConstraints {
        $0.height.equalTo(150)
    }
    
    return itemCell
}
