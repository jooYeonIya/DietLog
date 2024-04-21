//
//  ExerciseDetailViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit
import RealmSwift

class ExerciseViewController: BaseUIViewController {
    
    // MARK: - Componenet
    private lazy var noDatalabel = UILabel()
    private lazy var exerciseTableView = UITableView()
    private lazy var floatingButton = UIButton()
    
    // MARK: - 변수
    private let manager = ExerciseManager.shared
    private let selectedCategoryID: ObjectId
    private var exercise: [Exercise] = [] {
        didSet {
            let hasCategorieds = !exercise.isEmpty
            noDatalabel.isHidden = hasCategorieds
            exerciseTableView.isHidden = !hasCategorieds
            exerciseTableView.reloadData()
        }
    }
    
    // MARK: - 초기화
    init(categoryID: ObjectId) {
        self.selectedCategoryID = categoryID
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
        reloadExercise()
    }
    
    // MARK: - Setup UI
    override func setUI() {
        setNoDataLabelUI()
        setExerciseTableViewUI()
        setFloatingButtonUI()
    }
    
    private func setNoDataLabelUI() {
        noDatalabel.setupLabel(text: "데이터를 기록해 주세요", font: .body)
        view.addSubview(noDatalabel)
    }
    
    private func setExerciseTableViewUI() {
        exerciseTableView.register(ExerciseTableViewCell.self,
                                   forCellReuseIdentifier: ExerciseTableViewCell.identifier)
        view.addSubview(exerciseTableView)
    }
    
    private func setFloatingButtonUI() {
        floatingButton.setupFloatingButton()
        view.addSubview(floatingButton)
    }
    
    // MARK: - Setup Layout
    override func setLayout() {
        setNoDataLabelLayout()
        setTableLayout()
        setButtonLayout()
    }
    
    private func setNoDataLabelLayout() {
        noDatalabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setButtonLayout() {
        floatingButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.width.equalTo(52)
        }
    }
    
    private func setTableLayout() {
        exerciseTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Setup Delegate
    override func setDelegate() {
        exerciseTableView.dataSource = self
        exerciseTableView.delegate = self
    }

    // MARK: - Setup AddTarget
    override func setAddTartget() {
        floatingButton.addTarget(self, action: #selector(didTappedFloatingButton), for: .touchUpInside)
    }
}
// MARK: - 메서드
extension ExerciseViewController: ExerciseTableViewCellDelegate {
    
    private func reloadExercise() {
        if let result = manager.getAllExercise(for: selectedCategoryID) {
            exercise = Array(result)
        }
    }
    
    func didTappedOptionButton(_ cell: ExerciseTableViewCell) {
        guard let indexPath = exerciseTableView.indexPath(for: cell) else { return }
        
        let exercise = exercise[indexPath.row]
        
        showActionSheet(modifyCompletion: {
            let vc = ExerciseEditViewController(exercise: exercise)
            self.navigationController?.pushViewController(vc, animated: true)
        }, removeCompletion: {
            self.manager.deleteExercise(exercise)
            self.showAlertOneButton(title: "", message: "삭제했습니다") {
                self.reloadExercise()
            }
        })
    }
}

// MARK: - @objc 메서드
extension ExerciseViewController {
    
    @objc func didTappedFloatingButton() {
        let vc = ExerciseEditViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView
extension ExerciseViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercise.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier,
                                                       for: indexPath) as? ExerciseTableViewCell
        else { return UITableViewCell() }
        
        let exercise = exercise[indexPath.row]
        
        cell.delegate = self
        cell.configure(with: exercise)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WebViewController(youtubeURL: exercise[indexPath.row].URL)
        navigationController?.pushViewController(vc, animated: true)
    }
}
