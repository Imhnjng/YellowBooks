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
    let addButton = UIButton()
    let likeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = .gray
        return button
    }()
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
    
    var book: Document? {
        didSet {
            DispatchQueue.main.async {
                self.loadData()
            }
//            self.loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        configureUI()
    }
    
    func setupConstraints() {
       
        view.addSubview(bottomBar)
        bottomBar.addSubview(likeButton)
        bottomBar.addSubview(addButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backgroundThumbnail)
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
            $0.height.equalTo(80)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(60)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.leading.equalTo(likeButton.snp.trailing).offset(5)
            $0.top.bottom.trailing.equalToSuperview().inset(10)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
//            $0.edges.equalToSuperview()
        }
        
        backgroundThumbnail.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        thumnailImage.snp.makeConstraints {
            $0.centerX.equalTo(backgroundThumbnail.snp.centerX)
            $0.top.equalToSuperview().offset(50)
            $0.width.equalTo(contentView.snp.width).multipliedBy(0.5)
//            $0.height.equalTo(thumnailImage.snp.width).multipliedBy(1.4)
            $0.height.equalTo(300)
        }
        
        infoBackgroundView.snp.makeConstraints {
            $0.top.equalTo(backgroundThumbnail.snp.bottom).inset(20)
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(700)
        }
        
        booktitleLabel.snp.makeConstraints {
            $0.top.equalTo(infoBackgroundView.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
//        contentLabel.snp.makeConstraints {
//            $0.top.equalTo(booktitleLabel.snp.bottom).offset(10)
//            $0.leading.equalToSuperview().offset(16)
//        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(booktitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        translatorLabel.snp.makeConstraints {
            $0.centerY.equalTo(authorLabel.snp.centerY)
            $0.leading.equalTo(authorLabel.snp.trailing).offset(5)
        }
        
        publisherLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        }
        
        datetimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(publisherLabel.snp.centerY)
            $0.leading.equalTo(publisherLabel.snp.trailing).offset(5)
        }
        
//        isbnLabel
        
        salePriceLabel.snp.makeConstraints {
            $0.top.equalTo(publisherLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(salePriceLabel.snp.centerY)
            $0.leading.equalTo(salePriceLabel.snp.trailing).offset(5)
        }
        
    }
    
    func configureUI() {
        backgroundThumbnail.backgroundColor = .red
        
        bottomBar.backgroundColor = .white
        addButton.backgroundColor = .ybgray
        
        scrollView.backgroundColor = .yellow
        
        contentView.backgroundColor = .white
        
        thumnailImage.backgroundColor = .blue
        
        infoBackgroundView.backgroundColor = .white
        infoBackgroundView.layer.cornerRadius = 15
        
        
        booktitleLabel.text = "title title title title title"
        booktitleLabel.font = .systemFont(ofSize: 25, weight: .heavy)
        booktitleLabel.textColor = .black
        booktitleLabel.numberOfLines = 2
        
//        contentLabel
        authorLabel.text = "저자"
        authorLabel.font = .systemFont(ofSize: 17, weight: .medium)
        authorLabel.textColor = .black
        
        translatorLabel.text = "번역가"
        translatorLabel.font = .systemFont(ofSize: 17, weight: .medium)
        translatorLabel.textColor = .black
        
        publisherLabel.text = "출판사"
        publisherLabel.font = .systemFont(ofSize: 15, weight: .light)
        publisherLabel.textColor = .lightGray
        
        datetimeLabel.text = "0000년 00월 00일"
        datetimeLabel.font = .systemFont(ofSize: 15, weight: .light)
        datetimeLabel.textColor = .lightGray
        
//        isbnLabel

        salePriceLabel.text = "000000원"
        salePriceLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        salePriceLabel.textColor = .black
        
        priceLabel.text = "00000원"
        priceLabel.font = .systemFont(ofSize: 10, weight: .medium)
        priceLabel.textColor = .lightGray
    }
    
    // MARK: load data
    func loadData() {
        guard let book = book else { return }
        booktitleLabel.text = book.title
//        print("booktitleLabel.text: \(booktitleLabel.text) , book.title: \(book.title)")
        authorLabel.text = book.authors.joined(separator: ", ")
        translatorLabel.text = book.translators.joined(separator: ", ")
        publisherLabel.text = book.publisher
        datetimeLabel.text = book.datetime
        salePriceLabel.text = String((book.salePrice).formatted(.currency(code: "KRW")))
        priceLabel.text = String(book.price.formatted(.currency(code: "KRW")))
        backgroundThumbnail.loadFromURL(book.thumbnail)
        thumnailImage.loadFromURL(book.thumbnail)
    }
    
}

//extension UIImageView {
//    func loadFromURL(_ urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}

