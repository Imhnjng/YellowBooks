//
//  DetailViewController.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/4/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    let backgroundThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        //이미지에 블러 넣기
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 블러 처리된 이미지 뷰를 이미지 뷰 위에 추가
        imageView.addSubview(blurEffectView)
        
        return imageView
    }()
    
    let thumnailImage = UIImageView()
    let infoBackgroundView = UIView()
    var booktitleLabel = UILabel()
    var contentLabel = UILabel()
    var authorLabel = UILabel()
    var translatorLabel = UILabel()
    var publisherLabel = UILabel()
    var datetimeLabel = UILabel()
    var isbnLabel = UILabel()
//    var salePercent = UILabel()
    var priceLabel = UILabel()
    var salePriceLabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        configureUI()
    }
    
    func setupConstraints() {
        view.addSubview(backgroundThumbnail)
        view.addSubview(thumnailImage)
        view.addSubview(infoBackgroundView)
        infoBackgroundView.addSubview(booktitleLabel)
        infoBackgroundView.addSubview(contentLabel)
        infoBackgroundView.addSubview(authorLabel)
        infoBackgroundView.addSubview(translatorLabel)
        infoBackgroundView.addSubview(publisherLabel)
        infoBackgroundView.addSubview(datetimeLabel)
        infoBackgroundView.addSubview(isbnLabel)
        infoBackgroundView.addSubview(priceLabel)
        infoBackgroundView.addSubview(salePriceLabel)
    }
    
    func configureUI() {
        
    }
    

}
