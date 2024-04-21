//
//  SearchViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/07.
//

import UIKit

class SearchViewController: BaseUIViewController {
    
    // MARK: - Component
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
        collectionView.register(RecentSearchWordCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecentSearchWordCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    //MARK: - 변수
    private var recentSearchWords: [String] = [] {
        didSet {
            let hasData = !recentSearchWords.isEmpty
            noRecentSearchWordLabel.isHidden = hasData
            recentSearchWordCollectionView.isHidden = !hasData
            recentSearchWordCollectionView.reloadData()
        }
    }
    
    private var searchResults: [Exercise] = [] {
        didSet {
            let hasData = !searchResults.isEmpty
            noSearchResultLabel.isHidden = hasData
            searchResultTableView.isHidden = !hasData
            searchResultTableView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadRecentSearchData()
    }
    
    // MARK: - Setup UI
    override func setUI() {
        view.addSubview(recentSearchWordCollectionView)

        setSearchBarUI()
        setRecentSearchWordLabelUI()
        setDeleteRecentSearchWordButtonUI()
        setResultTableViewUI()
        setNoSearchResultLabelUI()
    }
    
    private func setSearchBarUI() {
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.searchBarStyle = .minimal
        
        searchBar.searchTextField.setupTextField()
        searchBar.searchTextField.borderStyle = .none
        
        searchBar.searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        view.addSubview(searchBar)
    }
    
    private func setRecentSearchWordLabelUI() {
        recentSearchWordLabel.setupLabel(text: "최근 검색어", font: .body)
        recentSearchWordLabel.textAlignment = .left
        
        noRecentSearchWordLabel.setupLabel(text: "최근 검색어가 없습니다", font: .smallBody)
        noRecentSearchWordLabel.textAlignment = .center
        
        view.addSubViews([recentSearchWordLabel, noRecentSearchWordLabel])
    }
    
    private func setDeleteRecentSearchWordButtonUI() {
        deleteRecentSearchWordButton.setTitle("전체 삭제", for: .normal)
        deleteRecentSearchWordButton.setTitleColor(.black, for: .normal)
        deleteRecentSearchWordButton.titleLabel?.font = .systemFont(ofSize: 12)
        view.addSubview(deleteRecentSearchWordButton)
    }
    
    private func setResultTableViewUI() {
        searchResultTableView.register(ExerciseTableViewCell.self,
                                       forCellReuseIdentifier: ExerciseTableViewCell.identifier)
        view.addSubview(searchResultTableView)
    }
    
    private func setNoSearchResultLabelUI() {
        noSearchResultLabel.setupLabel(text: "검색 결과가 없습니다", font: .body)
        noSearchResultLabel.textAlignment = .center
        view.addSubview(noSearchResultLabel)
    }
    
    
    // MARK: - Setup Layout
    override func setLayout() {
        setSearchBarLayout()
        setCollectinoViewLayout()
        setRecentSearchWordLabelLayout()
        setDeleteRecentSearchWordButtonLayout()
        setResultTableViewLayout()
        setNoSearchResultLabelLayout()
    }
    
    private func setSearchBarLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func setCollectinoViewLayout() {
        recentSearchWordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchWordLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(searchBar)
            make.height.equalTo(24)
        }
    }
    
    private func setRecentSearchWordLabelLayout() {
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
    
    private func setDeleteRecentSearchWordButtonLayout() {
        deleteRecentSearchWordButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearchWordLabel)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func setResultTableViewLayout() {
        searchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchWordCollectionView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(searchBar)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setNoSearchResultLabelLayout() {
        noSearchResultLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalTo(searchBar)
        }
    }
        
    // MARK: - Setup Delegate
    override func setDelegate() {
        searchBar.delegate = self

        recentSearchWordCollectionView.delegate = self
        recentSearchWordCollectionView.dataSource = self
 
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
    }
    
    // MARK: - AddTarget
    override func setAddTartget() {
        deleteRecentSearchWordButton.addTarget(self,
                                               action: #selector(didTappedDeleteRecentSearchWordButton),
                                               for: .touchUpInside)
    }
}

// MARK: - 메서드
extension SearchViewController {
    
    private func reloadRecentSearchData() {
        recentSearchWords = RecentSearchManager.shared.getAllRecentSearchWord()
    }
    
    private func reloadSearchData() {
        guard let searchText = searchBar.text else { return }
        if let result = ExerciseManager.shared.getAllExercise(with: searchText) {
            searchResults = Array(result)
        }
    }
    
    func didTappedDelegateButton() {
        reloadRecentSearchData()
        reloadSearchData()
    }
}

// MARK: - @objc 메서드
extension SearchViewController {
    
    @objc func didTappedDeleteRecentSearchWordButton() {
        RecentSearchManager.shared.deleteAllRecentSearchWord()
        reloadRecentSearchData()
        reloadSearchData()
    }
}

// MARK: - SearchBar
extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        RecentSearchManager.shared.add(to: searchText)
        reloadRecentSearchData()
        reloadSearchData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         if searchText.isEmpty {
             reloadRecentSearchData()
             reloadSearchData()
         }
     }
}

// MARK: - CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecentSearchWordCollectionViewCellDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentSearchWords.count == 0 ? 0 : recentSearchWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchWordCollectionViewCell.identifier,
                                                            for: indexPath) as? RecentSearchWordCollectionViewCell
        else { return UICollectionViewCell() }
        
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.text = recentSearchWords[indexPath.row]
        reloadSearchData()
    }
}

// MARK: - TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier,
                                                       for: indexPath) as? ExerciseTableViewCell
        else { return UITableViewCell() }
        
        let result = searchResults[indexPath.row]
        cell.configure(with: result)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
