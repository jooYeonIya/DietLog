//
//  ExerciseDetailViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit
import RealmSwift

class ExerciseDetailViewController: BaseUIViewController {
    
    private lazy var noDatalabel = UILabel()
    private lazy var tableView = UITableView()
    private lazy var floatingButton = UIButton()
    
    let selectedCategoryID: ObjectId
    
    var exercise: [Exercise]? {
        didSet {
            guard let hasCategorieds = exercise?.isEmpty else { return }
            
            noDatalabel.isHidden = !hasCategorieds
            tableView.isHidden = hasCategorieds
            tableView.reloadData()
        }
    }
    
    init(categoryID: ObjectId) {
        self.selectedCategoryID = categoryID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadExercise()
    }
    
    func reloadExercise() {
        if let result = Exercise.getAllExercise(for: selectedCategoryID) {
            exercise = Array(result)
        }
    }
    
    override func setUI() {
        setNoDataLabelUI()
        setTableViewUI()
        setButtonUI()
    }
    
    override func setLayout() {
        setNoDataLabelLayout()
        setTableLayout()
        setButtonLayout()
    }
    
    override func setDelegate() {
        setTableDalegate()
    }
    
    func setNoDataLabelUI() {
        noDatalabel.setupLabel(text: "데이터를 기록해 주세요", font: .body)
        view.addSubview(noDatalabel)
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
    
    func setNoDataLabelLayout() {
        noDatalabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func didTappedFloatingButton() {
        let vc = ExerciseDetailEditViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ExerciseDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func setTableViewUI() {
        tableView.register(ExerciseDetailTableViewCell.self, forCellReuseIdentifier: "ExerciseDetailTableViewCell")
        view.addSubview(tableView)
    }
    
    func setTableLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setTableDalegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // 내장 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercise?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseDetailTableViewCell", for: indexPath) as? ExerciseDetailTableViewCell else { return UITableViewCell() }
        
        guard let exercise = exercise?[indexPath.row] else { return UITableViewCell() }
        cell.configure(with: exercise)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
