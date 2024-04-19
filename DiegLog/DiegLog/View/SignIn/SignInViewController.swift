//
//  SignInViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit
import SnapKit
import Photos

class SignInViewController: BaseUIViewController {
    
    // MARK: - Componenet
    private lazy var welcomTitleLabel = UILabel()
    private lazy var welcomSubTitleLabel = UILabel()
    private lazy var nickNameTextField = UITextField()
    private lazy var saveButton = UIButton()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkPhotoStatus()
    }
    
    // MARK: - Setup UI
    override func setUI() {
        welcomTitleLabel.setupLabel(text: "안녕하세요!", font: .largeTitle)
        welcomSubTitleLabel.setupLabel(text: "접근 권한 설정이 필요합니다", font: .body)

        nickNameTextField.placeholder = "닉네임"
        nickNameTextField.isUserInteractionEnabled = false
        nickNameTextField.setupTextField()
        
        saveButton.setupButton(title: "저장", titleSize: .body)
        
        view.addSubViews([welcomTitleLabel, welcomSubTitleLabel, nickNameTextField, saveButton])
    }
    
    // MARK: - Setup Layout
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
    
    // MARK: - Setup AddTarget
    override func setAddTartget() {
        saveButton.addTarget(self, action: #selector(didTappedSaveButton), for: .touchUpInside)
    }
}

// MARK: - 메서드
extension SignInViewController {
    
    private func checkPhotoStatus() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                switch status {
                case .notDetermined, .restricted, .denied, .limited:
                    self.displaySettingsApp()
                case .authorized:
                    self.welcomSubTitleLabel.setupLabel(text: "앞으로 사용할 닉네임을 등록해주세요", font: .body)
                    self.nickNameTextField.isUserInteractionEnabled = true
                @unknown default:
                    fatalError("Unknown authorization status")
                }
            }
        }
    }
    
    private func displaySettingsApp() {
        let alertController = UIAlertController(title: "접근 권한 설정 필요",
                                                message: "사진 앨범에 대한 권한 설정을 해주세요",
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let settingsAppURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsAppURL)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(action)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
    
    @objc func didTappedSaveButton() {
        if nickNameTextField.text != "" {
            UserDefaults.standard.setValue(nickNameTextField.text, forKey: UserDefaultsKeys.nickName)
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isFirstLaunch)
            
            let tabBarViewController = AppTabBarController()
            view.window?.rootViewController = tabBarViewController
            view.window?.makeKeyAndVisible()
        } else {
            showAlertOneButton(title: "", message: "닉네임을 입력해 주세요")
        }
    }
}
    
