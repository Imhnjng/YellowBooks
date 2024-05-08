//
//  LibraryViewController.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/3/24.
//

import UIKit
import SnapKit
import CoreData

// 편집시 선택모드
enum Mode {
    case view
    case select
}

class LibraryViewController: UIViewController {
    static let shared = LibraryViewController()
//    private init() {}
    
    var dictionarySelectedIndexPath: [IndexPath : Bool] = [:]
//    var selectedIndexList: [IndexPath] = []
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    var bookList: [Book] = []
    
    let brandLogoImage = UIImageView(image: UIImage(named: "brandLogo"))
    let myLibraryLabel = UILabel()
   
    let libraryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let spacing: CGFloat = 8 // 내가 설정한 간격(minimumLineSpacing)이 8이므로
        let deviceWidth = UIScreen.main.bounds.width
        let countForLine: CGFloat = 3 // 한줄에 3개 넣을거니까
        let inset: CGFloat = 16 // 추가로 적용한 가로 inset
        
        let cellWidth = (deviceWidth - spacing * (countForLine - 1) - inset * 2 - 1)/countForLine
        
        layout.itemSize = .init(width: cellWidth, height: cellWidth * 2)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.allowsSelection = false
        return cv
    }()
    var editButton = UIButton()
    var trashButton = UIButton()
    let recentlyBookImageView = UIImageView()
 
    var editMode: Mode = .view {
        didSet {
            switch editMode {
            // view mode
            case .view:
                for (key, value) in dictionarySelectedIndexPath {
                    if value {
                        libraryCollectionView.deselectItem(at: key, animated: true)
                    }
                }
                dictionarySelectedIndexPath.removeAll()
                editButton.setTitle("Edit", for: .normal)
                editButton.setTitleColor(.ybgray, for: .normal)
                libraryCollectionView.allowsSelection = false
                trashButton.isHidden = true

            case .select:
                editButton.setTitle("Done", for: .normal)
                trashButton.isHidden = false
                libraryCollectionView.allowsSelection = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        libraryCollectionView.delegate = self
        libraryCollectionView.dataSource = self
        setBookList()
        
        setupConstraints()
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        setBookList()
    }
    
    
    // MARK: CoreData에서 상품 정보를 불러와, bookList 변수에 저장
    private func setBookList() {
        guard let context = self.persistentContainer?.viewContext else { return }
        let request = Book.fetchRequest()
        if let bookList = try? context.fetch(request) {
            self.bookList = bookList
        }
        libraryCollectionView.reloadData()
    }
    
    func setupConstraints() {
        view.addSubview(brandLogoImage)
        view.addSubview(myLibraryLabel)
        view.addSubview(libraryCollectionView)
        view.addSubview(editButton)
        view.addSubview(trashButton)
        view.addSubview(recentlyBookImageView)
        
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
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(myLibraryLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        trashButton.snp.makeConstraints {
            $0.centerY.equalTo(editButton.snp.centerY)
            $0.trailing.equalTo(editButton.snp.leading).offset(-5)
        }
        
        recentlyBookImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(110)
            $0.height.width.equalTo(50)
        }
        
    }
    
    func configureUI() {
        myLibraryLabel.text = "My Library"
        myLibraryLabel.textColor = .ybblack
        myLibraryLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        
        libraryCollectionView.backgroundColor = .white
        libraryCollectionView.register(LibraryCollectionViewCell.self, forCellWithReuseIdentifier: LibraryCollectionViewCell.identifier)
        
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.ybgray, for: .normal)
        editButton.addTarget(self, action: #selector(EditButton), for: .touchUpInside)
        
        trashButton.setTitle("Delect", for: .normal)
        trashButton.setTitleColor(.red, for: .normal)
        trashButton.addTarget(self, action: #selector(didSelectDelectButton), for: .touchUpInside)
        trashButton.isHidden = true
        
        recentlyBookImageView.backgroundColor = .gray
        recentlyBookImageView.contentMode = .scaleAspectFill
        recentlyBookImageView.clipsToBounds = true
        recentlyBookImageView.layer.cornerRadius = 25
    }
    
    //편집 -  뷰 모드 변경 토글
    @objc func EditButton(_ sender: UIButton) {
        print("편집모드변경 토글")
        editMode = editMode == .view ? .select : .view
    }
    
    // 삭제
    @objc func didSelectDelectButton(_ sender: UIButton) {
        print("삭제버튼")
        guard let context = self.persistentContainer?.viewContext else { return } //viewVontext 생성
        
        // 선택한 셀의 IndexPath를 기반으로 CoreData에서 해당 항목 삭제
        for (indexPath, _) in dictionarySelectedIndexPath {
            context.delete(bookList[indexPath.item])
        }
        
        // CoreData 변경사항 저장
        try? context.save()
        
        // 선택 되지 않는 책만 남김
        bookList = bookList.filter { book in
            let indexPath = IndexPath(item: bookList.firstIndex(of: book)!, section: 0)
            if dictionarySelectedIndexPath[indexPath] == nil {
                return true
            } else {
                return false
            }
        }
        
        dictionarySelectedIndexPath.removeAll() // 선택한 셀 제거 후 딕셔너리 초기화
        libraryCollectionView.reloadData()
        editMode = .view // 모드를 "뷰"로 변경
    }
        
    
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = libraryCollectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.identifier, for: indexPath) as? LibraryCollectionViewCell else { return LibraryCollectionViewCell() }
        
        let bookList = bookList[indexPath.item]
        cell.updateData(bookList)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("dictionarySelectedIndexPath: \(dictionarySelectedIndexPath)")
        dictionarySelectedIndexPath[indexPath] = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // 선택을 해제한 경우 딕셔너리에서 해당 IndexPath 제거
       dictionarySelectedIndexPath[indexPath] = nil
    }
}
