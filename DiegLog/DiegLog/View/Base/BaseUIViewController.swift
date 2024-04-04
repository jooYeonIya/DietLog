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
    
    func setupNavigationBar() {}
    
    func setUI() {}

    func setLayout() {}
    
    func setDelegate() {}
    
    func setAddTartget() {}
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
}
