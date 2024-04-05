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
    private lazy var imageLabel = UILabel()
    private lazy var imageView = UIImageView()
    private lazy var imageEditButton = UIButton()
    private lazy var memoLabel = UILabel()
    private lazy var memoTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        setDateLabelUI()
        setImageViewUI()
        setMemoTextViewUI()
    }
    
    override func setLayout() {
        setDateLabelLayout()
        setImageViewLayout()
        setMemoTextViewLayout()
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
    
    func setImageViewUI() {
        imageLabel.setupLabel(text: "사진 선택", font: .body)
        
        // 기본 이미지 찾은 뒤에 이미지와 버튼 설정 다시 해야한다
        imageView.image = UIImage(named: "testImege")
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        
        imageEditButton.setImage(UIImage(systemName: "plus"), for: .normal)
        imageEditButton.backgroundColor = .white
        imageEditButton.layer.cornerRadius = 20
        imageEditButton.layer.shadowRadius = 4
        imageEditButton.layer.shadowOpacity = 0.4

        view.addSubViews([imageLabel, imageView, imageEditButton])
    }
    
    func setMemoTextViewUI() {
        memoLabel.setupLabel(text: "메모", font: .body)
        
        memoTextView.layer.cornerRadius = 12
        memoTextView.layer.masksToBounds = true
        memoTextView.layer.borderColor = UIColor.black.cgColor
        memoTextView.layer.borderWidth = 1.0
        
        view.addSubViews([memoLabel, memoTextView])
    }
    
    func setDateLabelLayout() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    func setImageViewLayout() {
        imageLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(32)
            make.leading.trailing.equalTo(dateLabel)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(imageLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(dateLabel)
            make.height.equalTo(200)
        }
        
        imageEditButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(48)
            make.trailing.equalTo(imageView)
            make.width.height.equalTo(40)
        }
    }
    
    func setMemoTextViewLayout() {
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32)
            make.leading.trailing.equalTo(imageView)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(imageView)
            make.height.equalTo(200)
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
