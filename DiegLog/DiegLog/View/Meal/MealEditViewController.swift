//
//  MealEditViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit
import PhotosUI

class MealEditViewController: BaseUIViewController {
    
    private lazy var dateLabel = UILabel()
    private lazy var datePickerView = UIDatePicker()
    private lazy var imageLabel = UILabel()
    private lazy var imageView = UIImageView()
    private lazy var imageEditButton = UIButton()
    private lazy var memoLabel = UILabel()
    private lazy var memoTextView = UITextView()
    
    // model 전까지 dummy data로 사용
    var mealModel: [Any] = []
    
    var isEditable: Bool
    
    init(isEditable: Bool, mealModel: [Any]) {
        self.isEditable = isEditable
        self.mealModel = mealModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func setupNavigationBar() {
        var rightButton = UIBarButtonItem()
        
        if isEditable {
            rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveMealImage))
        } else {
            rightButton = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(displayActionSheet))
        }
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func setDateLabelUI() {
        let text = DateFormatter.toString(from: Date())
        dateLabel.setupLabel(text: text , font: .subTitle)
        dateLabel.textAlignment = .left
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(displayDatePickerView))
        dateLabel.addGestureRecognizer(tapGesture)
        dateLabel.isUserInteractionEnabled = isEditable

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
        imageEditButton.isHidden = !isEditable
        
        imageEditButton.addTarget(self, action: #selector(openPhotoLibrary), for: .touchUpInside)

        view.addSubViews([imageLabel, imageView, imageEditButton])
    }
    
    func setMemoTextViewUI() {
        memoLabel.setupLabel(text: "메모", font: .body)
        
        memoTextView.layer.cornerRadius = 12
        memoTextView.layer.masksToBounds = true
        memoTextView.layer.borderColor = UIColor.black.cgColor
        memoTextView.layer.borderWidth = 1.0
        memoTextView.isUserInteractionEnabled = isEditable
        
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
    
    @objc func saveMealImage() {
        print("save meal image")
    }
    
    @objc func displayActionSheet() {
        print("display action sheet")
    }
}

extension MealEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    guard let selectedImage = image as? UIImage else { return }
                    self.imageView.image = selectedImage
                }
            }
        }
    }
    
    @objc func openPhotoLibrary(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
}
