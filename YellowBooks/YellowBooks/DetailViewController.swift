//
//  DetailViewController.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/4/24.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    let bottomBar = UIView()
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
    
    let scrollView = UIScrollView()
    let contentView = UIView()
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
        
        view.addSubview(bottomBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(backgroundThumbnail)
        contentView.addSubview(thumnailImage)
        contentView.addSubview(infoBackgroundView)
        infoBackgroundView.addSubview(booktitleLabel)
        infoBackgroundView.addSubview(contentLabel)
        infoBackgroundView.addSubview(authorLabel)
        infoBackgroundView.addSubview(translatorLabel)
        infoBackgroundView.addSubview(publisherLabel)
        infoBackgroundView.addSubview(datetimeLabel)
        infoBackgroundView.addSubview(isbnLabel)
        infoBackgroundView.addSubview(priceLabel)
        infoBackgroundView.addSubview(salePriceLabel)
        
        
        bottomBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundThumbnail.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(contentView.snp.height).multipliedBy(0.5)
        }
        
        thumnailImage.snp.makeConstraints {
            $0.centerX.equalTo(backgroundThumbnail.snp.centerX)
            $0.top.equalToSuperview().offset(100)
            $0.width.equalTo(contentView.snp.width).multipliedBy(0.5)
//            $0.height.equalTo(thumnailImage.snp.width).multipliedBy(1.4)
            $0.height.equalTo(300)
        }
        
        infoBackgroundView.snp.makeConstraints {
            $0.top.equalTo(backgroundThumbnail.snp.bottom).inset(20)
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(700)
        }
    }
    
    func configureUI() {
        backgroundThumbnail.backgroundColor = .red
        
        bottomBar.backgroundColor = .orange
        
        scrollView.backgroundColor = .yellow
        
        contentView.backgroundColor = .green
        
        thumnailImage.backgroundColor = .blue
        
        infoBackgroundView.backgroundColor = .purple
    }
    

}
