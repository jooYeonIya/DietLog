//
//  ExerciseEditViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/06.
//

import UIKit

class ExerciseEditViewController: BaseUIViewController {
    private lazy var label = UILabel()
    private lazy var textField = UITextField()
    private lazy var rightButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        label.setupLabel(text: "카테고리 이름", font: .body)
        textField.setUpTextField()
        
        view.addSubViews([label, textField])
        
        rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveCategory))

        navigationItem.rightBarButtonItem = rightButton
    }
    
    override func setLayout() {
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview().dividedBy(3)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(12)
            make.leading.trailing.equalTo(label)
            make.height.equalTo(40)
        }
    }
    
    @objc func saveCategory() {
        guard let text = textField.text, !text.isEmpty else {
            showAlertOneButton(title: "", message: "카테고리 이름을 입력해 주세요")
            return
        }
        
        let category = ExerciseCategory()
        category.title = text
        
        ExerciseCategory.addExerciseCategory(category)
        
        showAlertOneButton(title: "", message: "저장했습니다") {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
