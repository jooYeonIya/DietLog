//
//  MealEditViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit

class MealEditViewController: BaseUIViewController {
    
    private lazy var dateLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        setDateLabelUI()
    }
    
    override func setLayout() {
        setDateLabelLayout()
    }
    
    func setDateLabelUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateLabel.setupLabel(text: dateFormatter.string(from: Date()) , font: .subTitle)
        dateLabel.textAlignment = .left
        
        view.addSubview(dateLabel)
    }
    
    func setDateLabelLayout() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
    }
}
