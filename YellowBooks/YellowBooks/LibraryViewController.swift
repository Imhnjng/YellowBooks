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
    
    var dictionarySelectedIndexPath: [IndexPath : Bool] = [:]
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    var bookList: [Book] = []
    
    let brandLogoImage = UIImageView(image: UIImage(named: "brandLogo"))
    let myLibraryLabel = UILabel()
    let delectAllButton = UIButton()
   
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
    var delectButton = UIButton()
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
                delectButton.isHidden = true
                delectAllButton.isHidden = true

            case .select:
                editButton.setTitle("Done", for: .normal)
                delectButton.isHidden = false
                delectButton.setImage(UIImage(systemName: "trash"), for: .normal)
                libraryCollectionView.allowsSelection = true
                delectAllButton.isHidden = false
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        print("LibraryViewController viewDidLoad @@@@@@@@@@@@@@@@")
        super.viewDidLoad()
        view.backgroundColor = .white
        libraryCollectionView.delegate = self
        libraryCollectionView.dataSource = self
        setBookList()
        
        setupConstraints()
        configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onRecentlyBookChanged(_:)), name: Notification.Name("RECENTLY_BOOK_CHANGED"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        setBookList()
    }
    
    @objc func onRecentlyBookChanged(_ noti: Notification) {
        print("onRecentlyBookChanged \(noti)")
        if let book = noti.userInfo?["book"] as? Document {
            print("thumbnail: \(book.thumbnail)")
            recentlyBookImageView.loadFromURL(book.thumbnail)
        }
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
        view.addSubview(delectAllButton)
        view.addSubview(myLibraryLabel)
        view.addSubview(libraryCollectionView)
        view.addSubview(editButton)
        view.addSubview(delectButton)
        view.addSubview(recentlyBookImageView)
        
        brandLogoImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(30)
        }
        
        delectAllButton.snp.makeConstraints {
            $0.top.equalTo(brandLogoImage.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        }
        
        myLibraryLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(delectAllButton.snp.centerY)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(myLibraryLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        libraryCollectionView.snp.makeConstraints {
            $0.top.equalTo(myLibraryLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        delectButton.snp.makeConstraints {
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
        
        delectAllButton.setTitle("Delect All", for: .normal)
        delectAllButton.setTitleColor(.ybgray, for: .normal)
        delectAllButton.addTarget(self, action: #selector(delectAllBooks), for: .touchUpInside)
        delectAllButton.isHidden = true
        
        libraryCollectionView.backgroundColor = .white
        libraryCollectionView.register(LibraryCollectionViewCell.self, forCellWithReuseIdentifier: LibraryCollectionViewCell.identifier)
        
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.ybgray, for: .normal)
        editButton.addTarget(self, action: #selector(EditButton), for: .touchUpInside)
        
//        delectButton.setTitle("Delect", for: .normal)
        delectButton.setTitleColor(.red, for: .normal)
        delectButton.addTarget(self, action: #selector(didSelectDelectButton), for: .touchUpInside)
        delectButton.isHidden = true
        
        recentlyBookImageView.backgroundColor = .clear
        recentlyBookImageView.contentMode = .scaleAspectFill
        recentlyBookImageView.clipsToBounds = true
        recentlyBookImageView.layer.cornerRadius = 25
    }
    
    //편집 -  뷰 모드 변경 토글
    @objc func EditButton(_ sender: UIButton) {
        print("편집모드변경 토글")
        editMode = editMode == .view ? .select : .view
    }
    
    // 선택 삭제
    @objc func didSelectDelectButton(_ sender: UIButton) {
        print("삭제버튼")
        guard let context = self.persistentContainer?.viewContext else { return } //viewContext 생성
        
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
    
    // 전체 삭제
    @objc func delectAllBooks() {
        print("전체삭제")
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
