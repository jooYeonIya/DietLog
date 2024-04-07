//
//  SearchViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/07.
//

import UIKit

class SearchViewController: BaseUIViewController {
    
    private lazy var searchBar = UISearchBar()
    
    private lazy var recentSearchWordCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(RecentSearchWordCollectionViewCell.self, forCellWithReuseIdentifier: "RecentSearchWordCollectionViewCell")
        
        return collectionView
    }()
    
    //MARK: - 변수
    var recentSearchWords: [String] = ["그러니까", "이게", "된다고?", "그러니까 이게 된다고?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        setSearchBarUI()
        setCollectinoViewUI()
    }
    
    override func setLayout() {
        setSearchBarLayout()
        setCollectinoViewLayout()
    }
        
    override func setDelegate() {
        setSerachBarDelegate()
        setCollectinoViewDelegate()
    }
}

// MARK: - SearchBar
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

// MARK: - CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setCollectinoViewUI() {
        view.addSubview(recentSearchWordCollectionView)
    }
    
    func setCollectinoViewLayout() {
        recentSearchWordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(24)
            make.leading.trailing.equalTo(searchBar)
            make.height.equalTo(24)
        }
    }
    
    func setCollectinoViewDelegate() {
        recentSearchWordCollectionView.delegate = self
        recentSearchWordCollectionView.dataSource = self
    }
    
    // 내장 메소드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentSearchWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentSearchWordCollectionViewCell", for: indexPath) as? RecentSearchWordCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: recentSearchWords[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentSearchWordCollectionViewCell", for: indexPath) as? RecentSearchWordCollectionViewCell else { return .zero }
        
        cell.recentSearchWordlabel.text = recentSearchWords[indexPath.row]
        cell.recentSearchWordlabel.sizeToFit()
        
        let cellWidth = cell.recentSearchWordlabel.frame.width + 12
        
        return CGSize(width: cellWidth, height: 24)
    }
}
