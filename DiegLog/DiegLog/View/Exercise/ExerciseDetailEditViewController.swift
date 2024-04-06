//
//  ExerciseDetailEditViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/06.
//

import UIKit

class ExerciseDetailEditViewController: BaseUIViewController {
    
    private lazy var URLlabel = UILabel()
    private lazy var textField = UITextField()
    private lazy var categoryLabel = UILabel()
    private lazy var rightButton = UIBarButtonItem()
    
    let cellSpacing = CGFloat(4)

    var category: [String] = ["카테고리", "몇개를", "3개를 하면 좋을 것 같네"]
    var selectedCategoryId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 나중에 코드 리팩토링 필요
    override func setUI() {
        setURLLbelUI()
        setCategoryLabel()
        setCategoryPlusButton()
        setSelectCategoryCollectionView()
        
        rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveURL))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func setURLLbelUI() {
        URLlabel.setupLabel(text: "영상 URL", font: .body)
        textField.setUpTextField()
        view.addSubViews([URLlabel, textField])
        
        URLlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().dividedBy(3)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(URLlabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(URLlabel)
            make.height.equalTo(40)
        }
    }
    
    func setCategoryLabel() {
        categoryLabel.setupLabel(text: "카테고리 선택", font: .body)
        view.addSubview(categoryLabel)
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(24)
            make.leading.equalTo(URLlabel)
        }
    }
    
    func setCategoryPlusButton() {
        let button = UIButton()
        button.setTitle("추가하기", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerY.equalTo(categoryLabel)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    @objc func saveURL() {
        guard let text = textField.text, !text.isEmpty, selectedCategoryId != nil else {
            showAlertOneButton(title: "", message: "URL 입력 및 카테고리 선택을 해주세요")
            return
        }
        
        if !isValidURL(with: text) {
            showAlertOneButton(title: "", message: "링크 주소가 올바르지 않습니다")
        } else {
            print("Asdf \(textField.text!)")
        }
    }
    
    func isValidURL(with text: String) -> Bool {
    
        if text.contains("youtube") || text.contains("youtu.be") {
            if let url = URL(string: text) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        
        return false
    }
}

extension ExerciseDetailEditViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setSelectCategoryCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.minimumInteritemSpacing = cellSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ExerciseDetailEditCollectionViewCell.self, forCellWithReuseIdentifier: "ExerciseDetailEditCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(URLlabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // 내장 메소드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseDetailEditCollectionViewCell", for: indexPath) as? ExerciseDetailEditCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(text: category[indexPath.row])
        cell.isSelected = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 48 - 16) / 3
        let height = width / 1.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryId = indexPath.row
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ExerciseDetailEditCollectionViewCell {
            cell.isSelected.toggle()
        }
    }
}
