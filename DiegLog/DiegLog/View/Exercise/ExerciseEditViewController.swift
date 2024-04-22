//
//  ExerciseDetailEditViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/06.
//

import UIKit
import RealmSwift

class ExerciseEditViewController: BaseUIViewController {
    
    // MARK: - Component
    private lazy var rightButton = UIBarButtonItem()
    
    private lazy var URLlabel = UILabel()
    private lazy var URLtextField = UITextField()
    
    private lazy var categoryLabel = UILabel()
    private lazy var noCategoryLabel = UILabel()
    private lazy var plusCategoryButton = UIButton()
    private lazy var categoryCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.minimumInteritemSpacing = cellSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ExerciseEditCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExerciseEditCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    // MARK: - 변수
    private var catergoryManager = ExerciseCatergoryManager.shared
    private var exerciseManager = ExerciseManager.shared
    private let cellSpacing = CGFloat(4)
    private var exercise: Exercise?
    private var selectedCategoryId: ObjectId?
    private var categories: [ExerciseCategory] = [] {
        didSet {
            let hasCategories = !categories.isEmpty
            noCategoryLabel.isHidden = hasCategories
            categoryCollectionView.isHidden = !hasCategories
            categoryCollectionView.reloadData()
        }
    }
    
    // MARK: - 초기화
    init(exercise: Exercise? = nil) {
        self.exercise = exercise
        self.selectedCategoryId = exercise?.categoryID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadCategories()
    }
    
    // MARK: - Setup UI
    override func setUI() {
        view.addSubview(categoryCollectionView)
        
        setURLLabelUI()
        setURLTextFieldUI()
        setCategoryLabelUI()
        setPlusCategoryButtonUI()
        setNoCategoryLabelUI()
    }
    
    private func setURLLabelUI() {
        URLlabel.setupLabel(text: "영상 URL", font: .body)
        view.addSubview(URLlabel)
    }
    
    private func setURLTextFieldUI() {
        if let exercise = exercise {
            URLtextField.text = exercise.URL
            URLtextField.isUserInteractionEnabled = false
        } else {
            URLtextField.setupTextField()
        }
        
        view.addSubview(URLtextField)
    }
    
    private func setCategoryLabelUI() {
        categoryLabel.setupLabel(text: "카테고리 선택", font: .body)
        view.addSubview(categoryLabel)
    }
    
    private func setNoCategoryLabelUI() {
        noCategoryLabel.setupLabel(text: "카테고리를 추가해 주세요", font: .smallBody)
        noCategoryLabel.textAlignment = .center
        view.addSubview(noCategoryLabel)
    }
    
    private func setPlusCategoryButtonUI() {
        plusCategoryButton.setTitle("추가하기", for: .normal)
        plusCategoryButton.setTitleColor(.black, for: .normal)
        plusCategoryButton.titleLabel?.font = .smallBody
        view.addSubview(plusCategoryButton)
    }

    // MARK: - Setup Layout
    override func setLayout() {
        URLlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().dividedBy(3)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
        
        URLtextField.snp.makeConstraints { make in
            make.top.equalTo(URLlabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(URLlabel)
            make.height.equalTo(44)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(URLtextField.snp.bottom).offset(24)
            make.leading.equalTo(URLlabel)
        }
        
        noCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(URLlabel)
        }
        
        plusCategoryButton.snp.makeConstraints { make in
            make.centerY.equalTo(categoryLabel)
            make.trailing.equalToSuperview().inset(24)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(URLlabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Setup AddTarget
    override func setAddTartget() {
        plusCategoryButton.addTarget(self, action: #selector(moveToCategoryView), for: .touchUpInside)
        
        rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveURL))
        navigationItem.rightBarButtonItem = rightButton
    }
}

// MARK: - 메서드
extension ExerciseEditViewController {
    
    private func reloadCategories() {
        if let result = catergoryManager.getAllExerciseCategories() {
            categories = Array(result)
        }
        
        for (index, category) in categories.enumerated() {
            if category.id == selectedCategoryId {
                let indexPath = IndexPath(item: index, section: 0)
                categoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            }
        }
    }
    
    private func isValidURL(with text: String) -> Bool {
        if text.contains("youtube") || text.contains("youtu.be") {
            if let url = URL(string: text) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        
        return false
    }
}

// MARK: - @objc 메서드
extension ExerciseEditViewController {
    
    @objc func moveToCategoryView() {
        let vc = CategoryEditViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func saveURL() {
        guard let text = URLtextField.text, !text.isEmpty, selectedCategoryId != nil else {
            showAlertOneButton(title: "", message: "URL 입력 및 카테고리 선택을 해주세요")
            return
        }
        
        if !isValidURL(with: text) {
            showAlertOneButton(title: "", message: "링크 주소가 올바르지 않습니다")
        } else {
            guard let url = URLtextField.text, let categoryID = selectedCategoryId else { return }
            
            if let exercise = exercise {
                exerciseManager.updateExercise(exercise, newCategoryID: categoryID)
            } else {
                YoutubeAPIService.shared.saveExercise(with: url, categoryID: categoryID)
            }
            
            self.showAlertOneButton(title: "", message: "저장했습니다") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - CollectionView
extension ExerciseEditViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseEditCollectionViewCell.identifier,
                                                            for: indexPath) as? ExerciseEditCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(text: categories[indexPath.row].title)
        cell.isSelected = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 48 - 16) / 3
        let height = width / 1.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryId = categories[indexPath.row].id
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ExerciseEditCollectionViewCell {
            cell.isSelected.toggle()
        }
    }
}
