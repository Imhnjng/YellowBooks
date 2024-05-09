//
//  SearchViewController.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/3/24.
//

import UIKit
import SnapKit
//import SwiftUI

class SearchViewController: UIViewController, DetailViewDelegate {
    
    let brandLogoImage = UIImageView(image: UIImage(named: "brandLogo"))
    let searchBar = UISearchBar()
    let searchResultLabel = UILabel()
    let tableView = UITableView()
    let recentlyBookImageView = UIImageView()
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickRecentBook))
    // 인스터스 프로퍼티는 생성자가 호출되는 시점에 초기화가 된다. 생성이 완료된 상태는 아니어서 self 사용불가. 사용할 시점에 초기화가 이뤄진다
    
    var searchBookDocuments: [Document] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        setupConstraints()
        configureUI()
    }
    
    
    func setupConstraints() {
        view.addSubview(brandLogoImage)
        view.addSubview(searchBar)
        view.addSubview(searchResultLabel)
        view.addSubview(tableView)
        view.addSubview(recentlyBookImageView)
        
        brandLogoImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalTo(searchBar.snp.top).offset(-10)
            $0.height.width.equalTo(30)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        searchResultLabel.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.equalTo(searchBar.snp.leading)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchResultLabel.snp.bottom).offset(10)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        recentlyBookImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(110)
            $0.height.width.equalTo(50)
        }
    }
    
    func configureUI() {
        searchBar.placeholder = "Search"
        searchBar.barTintColor = .white
        searchBar.layer.cornerRadius = 7
        searchBar.layer.borderWidth = 2
        searchBar.layer.borderColor = UIColor.ybgray.cgColor
        searchBar.backgroundImage = UIImage() //구분선 제거
        searchBar.searchTextField.backgroundColor = .white
        
        searchResultLabel.text = "Search Result"
        searchResultLabel.textColor = .ybblack
        tableView.backgroundColor = .white
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
        
        recentlyBookImageView.backgroundColor = .clear
        recentlyBookImageView.contentMode = .scaleAspectFill
        recentlyBookImageView.clipsToBounds = true
        recentlyBookImageView.layer.cornerRadius = 25
        recentlyBookImageView.isUserInteractionEnabled = true // 이미지뷰 클릭 이벤트 가능하게 해줌
        recentlyBookImageView.addGestureRecognizer(tapGesture)
        
    }
 
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        print("touchesBegan")
        self.view.endEditing(true)
    }

    func searchBook(keyword: String) {
        print("searchBook \(keyword)")
        // api 통신
        BookManager.shared.fetchBookData(withQuery: keyword, targets: [.title, .person]) { [weak self] success, response in
            if success, let response = response {
//                print("response: \(response)")
                
                // 결과값 모델
                self?.searchBookDocuments = response.documents
                
                // 테이블뷰 리로드
                self?.tableView.reloadData()
            }
            else {
                // TODO: error UI
                
            }
        }
    }
    
    @objc func clickRecentBook() {
        print(#function)
        
    }
    
    func addBookalert(message: String) {
        let alertVC = UIAlertController(title: "책 담기 완료!", message: " \(message)이(가) 라이브러리에 담겼습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchBookDocuments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as? ResultTableViewCell else { return ResultTableViewCell() }
        
        let item = searchBookDocuments[indexPath.row]
        cell.selectionStyle = .none
        cell.updateData(item)
//        cell.title.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectBook = searchBookDocuments[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.selectBook = selectBook

        // 현재 뷰 컨트롤러에서 모달 방식으로 네비게이션 컨트롤러 표시
        present(detailVC, animated: true)
        detailVC.delegate = self // 담기 눌렀을 때 delegate 위임
        recentlyBookImageView.loadFromURL(selectBook.thumbnail)
        
        if let tabBarController = self.tabBarController,
            let viewControllers = tabBarController.viewControllers,
            let navigationController = viewControllers[1] as? UINavigationController,
            let libraryVC = navigationController.viewControllers[0] as? LibraryViewController {
            libraryVC.recentlyBookImageView.loadFromURL(selectBook.thumbnail)
        }
        
//        let libraryVC = LibraryViewController() //새로운 인스턴스,,, 기존에 있는건 변함없음,,
//        libraryVC.recentlyBookImageView.loadFromURL(selectBook.thumbnail)
        
//        LibraryViewController.shared.recentlyBookImageView.loadFromURL(selectBook.thumbnail)
    }
    
    // 키보드외 터치 헀을 때 키보드 내려감
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        self.view.endEditing(true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        searchBar.resignFirstResponder()
        
        self.searchBook(keyword: text)
    }
}

#Preview {
    SearchViewController()  // 해당 컨트롤러
  // 화면 업데이트: command+option+p
}

//struct VCPreView: PreviewProvider {
//    static var previews: some View {
//        SearchViewController().toPreview()
//    }
//}
//#endif
