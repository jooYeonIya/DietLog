//
//  BaseUIViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

class BaseUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setUI()
        setLayout()
        setDelegate()
        setAddTartget()
    }
    
    func setupNavigationBar(isDisplayBackButton: Bool = false) {
        if isDisplayBackButton {
            let backButton = UIBarButtonItem(image: UIImage(named: "NavigationBackIcon"), style: .plain, target: self, action: #selector(didTappedBackButton))
            navigationItem.leftBarButtonItem = backButton
        }
        
        let attributes = [NSAttributedString.Key.font: UIFont.body]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setUI() {}

    func setLayout() {}
    
    func setDelegate() {}
    
    func setAddTartget() {}
    
    @objc func didTappedBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension BaseUIViewController {
    func showAlertOneButton(title: String?,
                            message: String?,
                            actionTitle: String = "확인",
                            completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            completion?()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(title: String? = nil,
                         message: String? = nil,
                         modifyTitle: String = "수정",
                         modifyCompletion: (() -> Void)? = nil,
                         removeTitle: String = "삭제",
                         removeCompletion: (() -> Void)? = nil) {
        
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let modify = UIAlertAction(title: modifyTitle, style: .default) { _ in
            modifyCompletion?()
        }
        
        let remove = UIAlertAction(title: removeTitle, style: .default) { _ in
            removeCompletion?()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(modify)
        actionSheet.addAction(remove)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
}
