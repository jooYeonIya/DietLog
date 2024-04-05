//
//  MealEditViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit

class MealEditViewController: BaseUIViewController {
    
    private lazy var dateLabel = UILabel()
    private lazy var datePickerView = UIDatePicker()

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
        let text = DateFormatter.toString(from: Date())
        dateLabel.setupLabel(text: text , font: .subTitle)
        dateLabel.textAlignment = .left
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(displayDatePickerView))
        dateLabel.addGestureRecognizer(tapGesture)
        dateLabel.isUserInteractionEnabled = true

        view.addSubview(dateLabel)
    }
    
    func setDateLabelLayout() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    

    @objc func displayDatePickerView() {
        let alert = UIAlertController(title: nil, message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(datePickerView)

        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .wheels
        
        datePickerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.dateLabel.text = DateFormatter.toString(from: self.datePickerView.date)
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
