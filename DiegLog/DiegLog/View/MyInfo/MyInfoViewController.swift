//
//  MyInfoViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

class MyInfoViewController: BaseUIViewController {
    
    private lazy var nickNameLabel = UILabel()
    
    let nickName = "닉네임"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        setNickNameLabelUI()
    }
    
    override func setLayout() {
        setNickNameLabelLayot()
    }
    
    func setNickNameLabelUI() {
        nickNameLabel.setupLabel(text: "안녕하세요 \(nickName)", font: .largeTitle)
        view.addSubview(nickNameLabel)
    }
    
    func setNickNameLabelLayot() {
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
    }
}
