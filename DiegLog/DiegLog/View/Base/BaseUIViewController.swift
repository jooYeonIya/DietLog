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
