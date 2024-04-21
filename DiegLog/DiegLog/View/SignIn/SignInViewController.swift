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
    private lazy var topTitle = UILabel()
    private lazy var backgroudView = UIView()
    private lazy var welcomTitleLabel = UILabel()
    private lazy var welcomSubTitleLabel = UILabel()
    private lazy var nickNameTextField = UITextField()
    private lazy var saveButton = UIButton()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkPhotoStatus()
    }
    
    // MARK: - Setup UI
    override func setUI() {
        
        topTitle.setupLabel(text: "DIET LOG", font: .largeTitle)
        topTitle.textAlignment = .center
        topTitle.textColor = .customGreen
        topTitle.numberOfLines = 2
        
        backgroudView.backgroundColor = .white
        backgroudView.layer.shadowOpacity = 0.4
        backgroudView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroudView.layer.shadowRadius = 2
        backgroudView.layer.cornerRadius = 16
        
        welcomTitleLabel.setupLabel(text: "안녕하세요!", font: .title)
        welcomSubTitleLabel.setupLabel(text: "사진 앨범에 대한 권한 설정을 해주세요", font: .body)

        nickNameTextField.placeholder = "닉네임"
        nickNameTextField.isUserInteractionEnabled = false
        nickNameTextField.setupTextField()
        
        saveButton.setupButton(title: "저장", titleSize: .body)
        
        view.addSubViews([topTitle,
                          backgroudView,
                          welcomTitleLabel,
                          welcomSubTitleLabel,
                          nickNameTextField,
                          saveButton])
    }
    
    // MARK: - Setup Layout
    override func setLayout() {
        backgroudView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(view.snp.height).dividedBy(3)
        }
        
        topTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backgroudView.snp.top).offset(-48)
        }
        
        welcomTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(backgroudView).inset(24)
        }

        welcomSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(welcomTitleLabel)
        }

        nickNameTextField.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(welcomSubTitleLabel.snp.bottom).offset(60)
            make.leading.trailing.equalTo(welcomTitleLabel)
            make.height.equalTo(44)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(12)
            make.bottom.greaterThanOrEqualTo(backgroudView.snp.bottom).inset(24)
            make.leading.trailing.equalTo(welcomTitleLabel)
            make.height.equalTo(44)
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
                    self.welcomSubTitleLabel.setupLabel(text: "앞으로 사용할 닉네임을 등록해 주세요", font: .body)
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
    
