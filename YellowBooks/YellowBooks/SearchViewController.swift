//
//  SearchViewController.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/3/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {

    let searchBar = UISearchBar()
    let searchResultLabel = UILabel()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()
        configureUI()
    }
    
    
    func setupConstraints() {
        view.addSubview(searchBar)
        view.addSubview(searchResultLabel)
        view.addSubview(tableView)
        
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
        searchBar.barTintColor = .systemBackground
        searchBar.layer.cornerRadius = 7
        searchBar.layer.borderWidth = 2
        searchBar.layer.borderColor = UIColor.ybgray.cgColor
        searchBar.backgroundImage = UIImage() //구분선 제거
        searchBar.searchTextField.backgroundColor = .systemBackground
        
        searchResultLabel.text = "Search Result"
        
        tableView.backgroundColor = .red
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

}
