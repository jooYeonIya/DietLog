//
//  ExerciseDetailEditViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/06.
//

import UIKit

class ExerciseDetailEditViewController: BaseUIViewController {
    private lazy var label = UILabel()
    private lazy var textField = UITextField()
    private lazy var rightButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        setURLLbelUI()
        setSelectCategory()
        
        rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveURL))

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
    
    func setURLLbelUI() {
        label.setupLabel(text: "영상 URL", font: .body)
        textField.setUpTextField()
        view.addSubViews([label, textField])
    }
    
    func setSelectCategory() {
        
    }
    
    @objc func saveURL() {
        guard let text = textField.text, !text.isEmpty else {
            showAlertOneButton(title: "", message: "URL을 입력해 주세요")
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
                print("asdfasf \(UIApplication.shared.canOpenURL(url as URL))")
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        
        return false
    }
}
