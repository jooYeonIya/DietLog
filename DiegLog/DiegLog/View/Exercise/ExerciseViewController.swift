//
//  ExerciseViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

class ExerciseViewController: BaseUIViewController {
    
    private lazy var noDatalabel: UILabel = {
        let label = UILabel()
        label.setupLabel(text: "데이터를 기록해 주세요", font: .body)
        label.isHidden = exerciseList.count == 0 ? false : true

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
    
    var exerciseList: [String] = ["Test"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        view.addSubViews([collectionView, noDatalabel])
    }
    
    override func setLayout() {
        setCollectionViewLayout()
        
        noDatalabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    override func setDelegate() {
        setCollectionViewDelegate()
    }
}

extension ExerciseViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    // 내장 메소드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exerciseList.count == 0 ? 0 : exerciseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCollectionViewCell", for: indexPath) as? ExerciseCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(text: exerciseList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 48 - cellSpacing) / 2
        return CGSize(width: width, height: width)
    }
}
