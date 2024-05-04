//
//  MainViewController.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/3/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    let brandLogoImage = UIImageView(image: UIImage(named: "brandLogo"))
    let searchBarView = UIView()
    let searchImage = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    //    let searchBarButton = UIButton()
    let allListLabel = UILabel()
    let allBookListColletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let spacing: CGFloat = 8 // 내가 설정한 간격(minimumLineSpacing)이 8이므로
        let deviceWidth = UIScreen.main.bounds.width
        let countForLine: CGFloat = 3 // 한줄에 3개 넣을거니까
        let inset: CGFloat = 16 // 추가로 적용한 가로 inset
        
        let cellWidth = (deviceWidth - spacing * (countForLine - 1) - inset * 2 - 1)/countForLine
        
        layout.itemSize = .init(width: cellWidth, height: cellWidth * 1.5)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        allBookListColletionView.dataSource = self
        allBookListColletionView.delegate = self
        setupConstraints()
        configureUI()
    }
    
    
    func setupConstraints() {
        view.addSubview(brandLogoImage)
        view.addSubview(searchBarView)
        searchBarView.addSubview(searchImage)
        view.addSubview(allListLabel)
        view.addSubview(allBookListColletionView)
        
        brandLogoImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(30)
        }
        
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(brandLogoImage.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        searchImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-14)
            $0.height.width.equalTo(22)
        }
        
        allListLabel.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        }
        
        allBookListColletionView.snp.makeConstraints {
            $0.top.equalTo(allListLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        searchBarView.backgroundColor = .systemBackground
        searchBarView.layer.cornerRadius = 7
        searchBarView.layer.borderWidth = 2
        searchBarView.layer.borderColor = UIColor.ybgray.cgColor
        searchBarView.tintColor = .ybgray
        searchImage.tintColor = .systemGray
        searchBarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToSearchView(_:))))
        
        allListLabel.text = "All Books"
        allListLabel.textColor = .ybblack
        allListLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        
        allBookListColletionView.backgroundColor = .clear
        allBookListColletionView.register(AllBookListCollectionViewCell.self, forCellWithReuseIdentifier: AllBookListCollectionViewCell.identifier)
    }
    
    @objc func goToSearchView(_ gesture: UITapGestureRecognizer) {
        print("clicked searchVIew")
        
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = allBookListColletionView.dequeueReusableCell(withReuseIdentifier: AllBookListCollectionViewCell.identifier, for: indexPath) as? AllBookListCollectionViewCell else { return AllBookListCollectionViewCell() }
        
        //        cell.layer.cornerRadius = 6
        return cell
    }
    
}
