//
//  LibraryCollectionViewCell.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/4/24.
//

import UIKit
import SnapKit

class LibraryCollectionViewCell: UICollectionViewCell {
    static let identifier = "LibraryCollectionViewCell"
    
    let image = UIImageView()
    let title = UILabel()
//    let author = UILabel()
    let salePrice = UILabel()
    let likeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemBackground
//        contentView.layer.cornerRadius = 6
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(_ data: Book) {
        title.text = data.title
//        author.text = data.authors.joined(separator: ", ")
        salePrice.text = String((data.salePrice).formatted(.currency(code: "KRW")))
        image.loadFromURL(data.thumbnail ?? "")
    }
    
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(image)
        contentView.addSubview(title)
//        contentView.addSubview(author)
        contentView.addSubview(salePrice)
        image.addSubview(likeButton)
        
        image.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(1.5)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
        }
        
        salePrice.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
//        likeButton.snp.makeConstraints {
//            $0.trailing.bottom.equalToSuperview().inset(8)
//        }
        
        image.backgroundColor = .blue
        
        title.text = "title title title title title"
        title.numberOfLines = 2
        title.textColor = .ybblack
        title.font = .systemFont(ofSize: 13, weight: .medium)
        
        salePrice.text = "salePrice"
        salePrice.numberOfLines = 1
        salePrice.textColor = .ybblack
        salePrice.font = .systemFont(ofSize: 12, weight: .light)
    }
    
}
