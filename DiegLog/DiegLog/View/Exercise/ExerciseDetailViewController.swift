//
//  ExerciseDetailViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit

class ExerciseDetailViewController: BaseUIViewController {
    
    private lazy var tableView = UITableView()
    private lazy var floatingButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        setTableViewUI()
        setButtonUI()
    }
    
    override func setLayout() {
        setTableLayout()
        setButtonLayout()
    }
    
    override func setDelegate() {
        setTableDalegate()
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
        print("운동 화면")
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseDetailTableViewCell", for: indexPath) as? ExerciseDetailTableViewCell else { return UITableViewCell() }
        cell.configure(model: ["test"])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
