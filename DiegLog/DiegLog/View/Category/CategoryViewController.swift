//
//  ExerciseViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

class CategoryViewController: BaseUIViewController {
    
    // MARK: - Componenet
    private lazy var floatingButton = UIButton()
    private lazy var noDatalabel = UILabel()
    private lazy var categoryCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(CategoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    // MARK: - 변수
    private var manager = ExerciseCatergoryManager.shared
    private var newTitle: String = ""
    private let cellSpacing = CGFloat(16)
    private var categories: [ExerciseCategory] = [] {
        didSet {
            let hasCategorieds = !categories.isEmpty
            noDatalabel.isHidden = hasCategorieds
            categoryCollectionView.isHidden = !hasCategorieds
            categoryCollectionView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadCategories()
    }
    
    // MARK: - Setup UI
    override func setUI() {
        view.addSubview(categoryCollectionView)
        setNoDataLabelUI()
        setButtonUI()
    }
    
    private func setNoDataLabelUI() {
        noDatalabel.setupLabel(text: "데이터를 기록해 주세요", font: .body)
        view.addSubview(noDatalabel)
    }
    
    private func setButtonUI() {
        floatingButton.setupFloatingButton()
        view.addSubview(floatingButton)
    }

    // MARK: - Setup Layout
    override func setLayout() {
        setCollectionViewLayout()
        setNoDataLabelLayout()
        setButtonLayout()
    }
    
    private func setButtonLayout() {
        floatingButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.width.equalTo(60)
        }
    }
    
    private func setNoDataLabelLayout() {
        noDatalabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setCollectionViewLayout() {
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Setup Dlegate
    override func setDelegate() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }
    
    // MARK: - Setup AddTarget
    override func setAddTartget() {
        floatingButton.addTarget(self, action: #selector(didTappedFloatingButton), for: .touchUpInside)
    }
}

// MARK: - 메서드
extension CategoryViewController: CategoryCollectionViewCellDelegate {
    
    private func reloadCategories() {
        if let result = manager.getAllExerciseCategories() {
            categories = Array(result)
        }
    }
    
    func didTappedOtpionButton(_ cell: CategoryCollectionViewCell) {
        guard let indexPath = categoryCollectionView.indexPath(for: cell) else { return }
        
        let category = categories[indexPath.row]
        
        showActionSheet(modifyCompletion: {
            self.showAlertWithTextField() {
                self.manager.updateExerciseCategory(category, newTitle: self.newTitle)
                self.showAlertOneButton(title: "", message: "수정했습니다.")
                self.reloadCategories()
            }
        }, removeCompletion: {
            if let exercise = Exercise.getAllExercise(for: category.id) {
                exercise.forEach {
                    Exercise.deleteExercise($0)
                }
            }
            
            self.manager.deleteExerciseCategory(category)
            
            self.showAlertOneButton(title: "", message: "삭제했습니다") {
                self.reloadCategories()
            }
        })
    }
    
    private func showAlertWithTextField(completion: (() -> Void)?) {
        
        let alert = UIAlertController(title: "카테고리 이름", message: "이름을 입력해 주세요", preferredStyle: .alert)
        
        alert.addTextField()
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak alert] _ in
            if let textField = alert?.textFields?.first, let text = textField.text {
                self.newTitle = text
                completion?()
            }
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - @objc 메서드
extension CategoryViewController {
    
    @objc func didTappedFloatingButton() {
        let vc = CategoryEditViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier,
                                                            for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(text: categories[indexPath.row].title)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 48 - cellSpacing) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ExerciseViewController(categoryID: (categories[indexPath.row].id))
        navigationController?.pushViewController(vc, animated: true)
    }
}
