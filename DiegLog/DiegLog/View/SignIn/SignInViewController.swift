//
//  SignInViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit
import SnapKit

class SignInViewController: BaseUIViewController {
    private lazy var welcomTitleLabel = UILabel()
    private lazy var welcomSubTitleLabel = UILabel()
    private lazy var nickNameTextField = UITextField()
    private lazy var saveButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        welcomTitleLabel.setupLabel(text: "안녕하세요!", font: .largeTitle)
        welcomSubTitleLabel.setupLabel(text: "앞으로 사용할 닉네임을 등록해주세요", font: .body)
        
        nickNameTextField.placeholder = "닉네임"
        nickNameTextField.setUpTextField()
        
        saveButton.setUpButton(title: "저장", titleSize: .body)
        
        view.addSubview(welcomTitleLabel)
        view.addSubview(welcomSubTitleLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(saveButton)
    }
    
    override func setLayout() {
        welcomTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().dividedBy(2)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        welcomSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(welcomTitleLabel)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(welcomSubTitleLabel.snp.bottom).offset(60)
            make.leading.trailing.equalTo(welcomTitleLabel)
            make.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(24)
            make.leading.trailing.equalTo(welcomTitleLabel)
            make.height.equalTo(40)
        }
    }
    
    override func setAddTartget() {
        saveButton.addTarget(self, action: #selector(didTappedSaveButton), for: .touchUpInside)
    }
    
    @objc func didTappedSaveButton() {

        if nickNameTextField.text != "" {
            //        UserDefaults.standard.setValue(true, forKey: "isFirstLaunch")
        } else {
            showAlertOneButton(title: "", message: "닉네임을 입력해 주세요")
        }
    }
}
