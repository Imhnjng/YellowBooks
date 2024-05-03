//
//  ResultTableViewCell.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/3/24.
//

import UIKit
import SnapKit

class ResultTableViewCell: UITableViewCell {
    static let identifier = "ResultTableViewCell"
    
    let image = UIImageView()
    let title = UILabel()
    let author = UILabel()
//    let salePercent = UILabel()
    let salePrice = UILabel()
    lazy var stackView = UIStackView(arrangedSubviews: [title, author, salePrice])
//    let likeButton = UIButton()
    let likeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        contentView.addSubview(image)
        contentView.addSubview(stackView)
        contentView.addSubview(likeButton)
        
//        contentView.snp.makeConstraints {
//            $0.height.equalTo(90)
//        }
        
        image.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-5)
//            $0.height.equalTo(80)
            $0.width.equalTo(70)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(image.snp.trailing).offset(10)
            $0.centerY.equalTo(image.snp.centerY)
            $0.trailing.equalTo(likeButton.snp.leading).offset(-10)
        }
        
        likeButton.snp.makeConstraints {
//            $0.leading.equalTo(stackView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-5)
//            $0.height.width.equalTo(50)
            $0.centerY.equalTo(stackView.snp.centerY)
        }
    }
    
    func configureUI() {
        image.backgroundColor = .gray
        image.layer.cornerRadius = 6
        
        title.text = "booktitle booktitle booktitle booktitle booktitle"
        title.textColor = .ybblack
        title.numberOfLines = 2
        title.font = .systemFont(ofSize: 17, weight: .medium)
        
        author.text = "Jerry Jerry Jerry"
        author.textColor = .systemGray
        author.numberOfLines = 1
        author.font = .systemFont(ofSize: 15, weight: .light)
        
        salePrice.text = "0000 원"
        salePrice.textColor = .ybblack
        salePrice.font = .systemFont(ofSize: 15, weight: .regular)
        
        stackView.axis = .vertical
        stackView.spacing = 1
//        stackView.distribution = .fillEqually
        stackView.alignment = .fill
 
        
    }
    
    
    
    
    override func awakeFromNib() {
        
       
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
