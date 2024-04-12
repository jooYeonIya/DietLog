//
//  ExerciseViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

class ExerciseViewController: BaseUIViewController {
    
    private lazy var floatingButton = UIButton()
    
    private lazy var noDatalabel: UILabel = {
        let label = UILabel()
        label.setupLabel(text: "데이터를 기록해 주세요", font: .body)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ExerciseCollectionViewCell.self, forCellWithReuseIdentifier: "ExerciseCollectionViewCell")
        
        return collectionView
    }()
    
    let cellSpacing = CGFloat(16)
    
    var categories: [ExerciseCategory]? {
        didSet {
            guard let hasCategorieds = categories?.isEmpty else { return }
            
            noDatalabel.isHidden = !hasCategorieds
            collectionView.isHidden = hasCategorieds
            collectionView.reloadData()
        }
    }
    
    var newTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadCategories()
    }
    
    func reloadCategories() {
        if let result = ExerciseCategory.getAllExerciseCategories() {
            categories = Array(result)
        }
    }
    
    override func setUI() {
        view.addSubViews([collectionView, noDatalabel])
        
        setButtonUI()
    }
    
    override func setLayout() {
        setCollectionViewLayout()
        setButtonLayout()
        
        noDatalabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    override func setDelegate() {
        setCollectionViewDelegate()
    }
    
    func setButtonUI() {
        floatingButton.setUpFloatingButton()
        floatingButton.addTarget(self, action: #selector(didTappedFloatingButton), for: .touchUpInside)
        view.addSubview(floatingButton)
    }
    
    func setButtonLayout() {
        floatingButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.width.equalTo(60)
        }
    }
    
    @objc func didTappedFloatingButton() {
        let vc = ExerciseEditViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ExerciseViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,  ExerciseCollectionViewCellDelegate {
    
    func setCollectionViewLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setCollectionViewDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func didTappedOtpionButton(_ cell: ExerciseCollectionViewCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell), let category = categories?[indexPath.row] else { return }
        
        showActionSheet(modifyCompletion: {
            self.showAlertWithTextField() {
                ExerciseCategory.updateExerciseCategory(category, newTitle: self.newTitle)
                self.showAlertOneButton(title: "", message: "수정했습니다.")
                self.reloadCategories()
            }
        }, removeCompletion: {
            ExerciseCategory.deleteExerciseCategory(category)
            self.showAlertOneButton(title: "", message: "삭제했습니다") {
                self.reloadCategories()
            }
        })
    }

    func showAlertWithTextField(completion: (() -> Void)?) {
        
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
    
    // 내장 메소드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCollectionViewCell", for: indexPath) as? ExerciseCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(text: categories?[indexPath.row].title ?? "카테고리")
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 48 - cellSpacing) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ExerciseDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
