//
//  LibraryViewController.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/3/24.
//

import UIKit
import SnapKit
import CoreData

class LibraryViewController: UIViewController {
    //
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    var bookList: [Book] = []
    
    let brandLogoImage = UIImageView(image: UIImage(named: "brandLogo"))
    let myLibraryLabel = UILabel()
   
    let libraryCollectionView: UICollectionView = {
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
        
        layout.itemSize = .init(width: cellWidth, height: cellWidth * 2)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        libraryCollectionView.delegate = self
        libraryCollectionView.dataSource = self
        setBookList()
        
        setupConstraints()
        configureUI()
        
    }
    
    // MARK: CoreData에서 상품 정보를 불러와, bookList 변수에 저장
    private func setBookList() {
        print("setBookList - bookList: \(bookList)")
        guard let context = self.persistentContainer?.viewContext else { return }
    
        let request = Book.fetchRequest()
    
        if let bookList = try? context.fetch(request) {
            self.bookList = bookList
        }
    }
    
    func setupConstraints() {
        view.addSubview(brandLogoImage)
        view.addSubview(myLibraryLabel)
        view.addSubview(libraryCollectionView)
        
        brandLogoImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(30)
        }
        
        myLibraryLabel.snp.makeConstraints {
            $0.top.equalTo(brandLogoImage.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        }
        
        libraryCollectionView.snp.makeConstraints {
            $0.top.equalTo(myLibraryLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    func configureUI() {
        myLibraryLabel.text = "My Library"
        myLibraryLabel.textColor = .ybblack
        myLibraryLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        
        libraryCollectionView.backgroundColor = .white
        libraryCollectionView.register(LibraryCollectionViewCell.self, forCellWithReuseIdentifier: LibraryCollectionViewCell.identifier)
    }
    
    
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = libraryCollectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.identifier, for: indexPath) as? LibraryCollectionViewCell else { return LibraryCollectionViewCell() }
        
        let bookList = bookList[indexPath.item]
        
        return cell
    }
    
}
