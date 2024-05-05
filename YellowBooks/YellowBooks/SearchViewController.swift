//
//  SearchViewController.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/3/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    let brandLogoImage = UIImageView(image: UIImage(named: "brandLogo"))
    let searchBar = UISearchBar()
    let searchResultLabel = UILabel()
    let tableView = UITableView()
    
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
                print("response: \(response)")
                
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
