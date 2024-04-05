//
//  ExerciseDetailViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit

class ExerciseDetailViewController: BaseUIViewController {
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        setTableViewUI()
    }
    
    override func setLayout() {
        setTableLayout()
    }
    
    override func setDelegate() {
        setTableDalegate()
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
