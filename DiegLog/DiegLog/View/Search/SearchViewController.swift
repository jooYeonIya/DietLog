//
//  SearchViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/07.
//

import UIKit

class SearchViewController: BaseUIViewController {
    
    private lazy var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        setSearchBarUI()
    }
    
    override func setLayout() {
        setSearchBarLayout()
    }
        
    override func setDelegate() {
        setSerachBarDelegate()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func setSearchBarUI() {
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.searchBarStyle = .minimal
        
        searchBar.searchTextField.setUpTextField()
        searchBar.searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        view.addSubview(searchBar)
    }
    
    func setSearchBarLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    func setSerachBarDelegate() {
        searchBar.delegate = self
    }
}
