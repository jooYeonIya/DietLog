//
//  SearchViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/07.
//

import UIKit

class SearchViewController: BaseUIViewController {
    
    private lazy var searchBar = UISearchBar()
    private lazy var recentSearchWordLabel = UILabel()
    private lazy var noRecentSearchWordLabel = UILabel()
    private lazy var deleteRecentSearchWordButton = UIButton()
    private lazy var searchResultTableView = UITableView()
    private lazy var noSearchResultLabel = UILabel()
    
    private lazy var recentSearchWordCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(RecentSearchWordCollectionViewCell.self, forCellWithReuseIdentifier: "RecentSearchWordCollectionViewCell")
        
        return collectionView
    }()
    
    //MARK: - 변수
    var recentSearchWords: [String] = [] {
        didSet {
            let hasData = !recentSearchWords.isEmpty
            noRecentSearchWordLabel.isHidden = hasData
            recentSearchWordCollectionView.isHidden = !hasData
            recentSearchWordCollectionView.reloadData()
        }
    }
    var searchResults: [String] = ["이게", "검색", "결과입니다만"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    func reloadData() {
        recentSearchWords = RecentSearchManager.shared.getAllRecentSearchWord()
    }
    
    override func setUI() {
        setSearchBarUI()
        setCollectinoViewUI()
        setRecentSearchWordLabelUI()
        setDeleteRecentSearchWordButtonUI()
        setResultTableViewUI()
        setNoSearchResultLabelUI()
    }
    
    override func setLayout() {
        setSearchBarLayout()
        setCollectinoViewLayout()
        setRecentSearchWordLabelLayout()
        setDeleteRecentSearchWordButtonLayout()
        setResultTableViewLayout()
        setNoSearchResultLabelLayout()
    }
        
    override func setDelegate() {
        setSerachBarDelegate()
        setCollectinoViewDelegate()
        setResultTableViewDelegate()
    }
    
    func setRecentSearchWordLabelUI() {
        recentSearchWordLabel.setupLabel(text: "최근 검색어", font: .body)
        recentSearchWordLabel.textAlignment = .left
        
        noRecentSearchWordLabel.setupLabel(text: "최근 검색어가 없습니다", font: .smallBody)
        noRecentSearchWordLabel.textAlignment = .center
        
        view.addSubViews([recentSearchWordLabel, noRecentSearchWordLabel])
    }
    
    func setDeleteRecentSearchWordButtonUI() {
        deleteRecentSearchWordButton.setTitle("전체 삭제", for: .normal)
        deleteRecentSearchWordButton.setTitleColor(.black, for: .normal)
        deleteRecentSearchWordButton.titleLabel?.font = .systemFont(ofSize: 12)
        view.addSubview(deleteRecentSearchWordButton)
    }
    
    func setNoSearchResultLabelUI() {
        noSearchResultLabel.setupLabel(text: "검색 결과가 없습니다", font: .body)
        noSearchResultLabel.textAlignment = .center
        noSearchResultLabel.isHidden = searchResults.count == 0 ? false : true
        view.addSubview(noSearchResultLabel)
    }
    
    func setRecentSearchWordLabelLayout() {
        recentSearchWordLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(24)
            make.leading.equalTo(searchBar)
        }
        
        noRecentSearchWordLabel.snp.makeConstraints { make in
            make.top.equalTo(recentSearchWordLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(searchBar)
            make.height.equalTo(24)
        }
    }
    
    func setDeleteRecentSearchWordButtonLayout() {
        deleteRecentSearchWordButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearchWordLabel)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    func setNoSearchResultLabelLayout() {
        noSearchResultLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalTo(searchBar)
        }
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
    
    // 내장 메소드
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        RecentSearchManager.shared.add(to: searchText)
        reloadData()
    }
}

// MARK: - CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecentSearchWordCollectionViewCellDelegate {
    
    func setCollectinoViewUI() {
        view.addSubview(recentSearchWordCollectionView)
    }
    
    func setCollectinoViewLayout() {
        recentSearchWordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchWordLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(searchBar)
            make.height.equalTo(24)
        }
    }
    
    func setCollectinoViewDelegate() {
        recentSearchWordCollectionView.delegate = self
        recentSearchWordCollectionView.dataSource = self
    }
    
    func didTappedDelegateButton() {
        reloadData()
    }
    
    // 내장 메소드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentSearchWords.count == 0 ? 0 : recentSearchWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentSearchWordCollectionViewCell", for: indexPath) as? RecentSearchWordCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: recentSearchWords[indexPath.row])
        cell.deleteButton.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = recentSearchWords[indexPath.row]
        let font = UIFont.systemFont(ofSize: 14)
        let textAttributes = [NSAttributedString.Key.font: font]
        let textWidth = (text as NSString).size(withAttributes: textAttributes).width

        let additionalSpacing: CGFloat = 20
        let deleteButtonWidth: CGFloat = 24
        let cellWidth = textWidth + deleteButtonWidth + additionalSpacing
        return CGSize(width: cellWidth, height: 24)
    }

}

// MARK: - TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func setResultTableViewUI() {
        searchResultTableView.register(ExerciseDetailTableViewCell.self, forCellReuseIdentifier: "ExerciseDetailTableViewCell")
        view.addSubview(searchResultTableView)
    }
    
    func setResultTableViewLayout() {
        searchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchWordCollectionView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(searchBar)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setResultTableViewDelegate() {
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
    }
    
    // 내장 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count == 0 ? 0 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseDetailTableViewCell", for: indexPath) as? ExerciseDetailTableViewCell else { return UITableViewCell() }
        
        // 추후 작업 반드시 필요
//        cell.configure(with: searchResults)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
