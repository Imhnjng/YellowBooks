//
//  ResultTableViewCell.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/3/24.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    let image = UIImageView()
    let title = UILabel()
    let author = UILabel()
    let salePercent = UILabel()
    let salePrice = UILabel()
    let likeButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        contentView.addSubview(<#T##view: UIView##UIView#>)
    }
    
    func configureUI() {
        
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
