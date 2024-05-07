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
//    let likeButton: UIButton = {
//        let button = UIButton()
//        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
//        let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
//        
//        button.setImage(image, for: .normal)
//        button.tintColor = .white
//        return button
//    }()
    
    let highLightView = UIView()
    let highLightBorderView = UIView()
    

    // 편집시 하이라이트
//    override var isHighlighted: Bool {
//       didSet {
//           highLightView.isHidden = !isHighlighted
//           highLightBorderView.isHidden = !isHighlighted
//       }
//   }

   override var isSelected: Bool {
       didSet {
//           print("isSelected, \(isSelected)")
           highLightView.isHidden = !isSelected
           highLightBorderView.isHidden = !isSelected
       }
   }

    
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
//        image.addSubview(likeButton)
        
        contentView.addSubview(highLightBorderView)
        contentView.addSubview(highLightView)
        
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
        
        highLightView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(-4)
            $0.bottom.trailing.equalToSuperview().inset(-4)
        }
        
        highLightBorderView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(-4)
            $0.bottom.trailing.equalToSuperview().inset(-4)
        }
        
        contentView.layer.cornerRadius = 6
        image.backgroundColor = .blue
        
        title.text = "title title title title title"
        title.numberOfLines = 2
        title.textColor = .ybblack
        title.font = .systemFont(ofSize: 13, weight: .medium)
        
        salePrice.text = "salePrice"
        salePrice.numberOfLines = 1
        salePrice.textColor = .ybblack
        salePrice.font = .systemFont(ofSize: 12, weight: .light)
        
        highLightView.backgroundColor = .ybyellow
        highLightView.layer.opacity = 0.3
        highLightView.layer.cornerRadius = 6
        highLightView.isHidden = true
        highLightBorderView.layer.borderColor = UIColor.ybyellow.cgColor
        highLightBorderView.layer.borderWidth = 3
        highLightBorderView.layer.cornerRadius = 6
        highLightBorderView.isHidden = true
    }
}
