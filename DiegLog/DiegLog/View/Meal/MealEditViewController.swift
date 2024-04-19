//
//  MealEditViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit
import PhotosUI
import RealmSwift

class MealEditViewController: BaseUIViewController {
    
    // MARK: - Component
    private lazy var dateLabel = UILabel()
    private lazy var datePickerView = UIDatePicker()
    private lazy var imageLabel = UILabel()
    private lazy var imageView = UIImageView()
    private lazy var imageEditButton = UIButton()
    private lazy var memoLabel = UILabel()
    private lazy var memoTextView = UITextView()
    
    // MARK: - 변수
    private var manager = MealManager.shared
    private var selectedDate: Date
    private let mealId: ObjectId?
    private var mealData: Meal? {
        didSet {
            guard let imagePath = mealData?.imagePath else { return }
            imageView.image = ImageFileManager.shared.loadImage(with: imagePath)
            memoTextView.text = mealData?.memo
        }
    }
    
    private var isEditable: Bool {
        willSet {
            toggleEditSetup(isEditable: newValue)
        }
    }
    
    // MARK: - 초기화
    init(mealId: ObjectId?, selectedDate: Date) {
        self.mealId = mealId
        self.selectedDate = selectedDate
        self.isEditable = mealId == nil
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadMealData()
    }
    
    // MARK: - Setup UI
    override func setUI() {
        setDateLabelUI()
        setImageSectionUI()
        setMemoTextSectionUI()
    }
    
    private func setDateLabelUI() {
        let dateString = DateFormatter.toString(from: selectedDate)
        let text = isEditable ? "\(dateString) ▽" : "\(dateString)"
        dateLabel.setupLabel(text: text, font: .subTitle)
        dateLabel.textAlignment = .left

        view.addSubview(dateLabel)
    }
    
    private func setImageSectionUI() {
        imageLabel.setupLabel(text: "사진 선택", font: .body)
        
        // 기본 이미지 찾은 뒤에 이미지와 버튼 설정 다시 해야한다
        imageView.image = UIImage(named: "FoodBasicImage")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        
        imageEditButton.setImage(UIImage(systemName: "plus"), for: .normal)
        imageEditButton.backgroundColor = .white
        imageEditButton.layer.cornerRadius = 20
        imageEditButton.layer.shadowRadius = 4
        imageEditButton.layer.shadowOpacity = 0.4
        imageEditButton.isHidden = !isEditable
        
        view.addSubViews([imageLabel, imageView, imageEditButton])
    }
    
    private func setMemoTextSectionUI() {
        memoLabel.setupLabel(text: "메모", font: .body)
        
        memoTextView.layer.cornerRadius = 12
        memoTextView.layer.masksToBounds = true
        memoTextView.layer.borderColor = UIColor.black.cgColor
        memoTextView.layer.borderWidth = 1.0
        memoTextView.isUserInteractionEnabled = isEditable
        
        view.addSubViews([memoLabel, memoTextView])
    }
    
    // MARK: - Setup Layout
    override func setLayout() {
        setDateLabelLayout()
        setImageSectionLayout()
        setMemoTextSectionLayout()
    }
    
    private func setDateLabelLayout() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func setImageSectionLayout() {
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
    
    private func setMemoTextSectionLayout() {
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
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        navigationItem.rightBarButtonItem = setNavigationRightButton(isEditable)
    }
    
    private func setNavigationRightButton(_ isEditable: Bool) -> UIBarButtonItem {
        if isEditable {
            return UIBarButtonItem(title: "저장",
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTappedRigthButton))
        } else {
            return UIBarButtonItem(image: UIImage(systemName: "photo"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(displayActionSheet))
        }
    }
    
    // MARK: - Setup AddTarget
    override func setAddTartget() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(displayDatePickerView))
        dateLabel.addGestureRecognizer(tapGesture)
        dateLabel.isUserInteractionEnabled = isEditable
        
        imageEditButton.addTarget(self, action: #selector(openPhotoLibrary), for: .touchUpInside)
    }
}

// MARK: - 메서드
extension MealEditViewController {
    
    private func reloadMealData() {
        if let id = mealId {
            mealData = manager.getMeal(for: id)
        }
    }
    
    private func createMealData() -> Meal {
        let meal = Meal()
        
        if let folderName = dateLabel.text, let image = imageView.image {
            
            let imageName = UUID().uuidString
            ImageFileManager.shared.saveImage(folderName: folderName, imageName: "\(imageName).png", image: image)
            
            meal.folderName = folderName
            meal.imageName = imageName
            meal.memo = memoTextView.text
            meal.postedDate = selectedDate
        }
        
        return meal
    }
    
    private func toggleEditSetup(isEditable: Bool) {
        let dateString = DateFormatter.toString(from: selectedDate)
        let text = isEditable ? "\(dateString) ▽" : "\(dateString)"
        dateLabel.setupLabel(text: text, font: .subTitle)
        dateLabel.isUserInteractionEnabled.toggle()
        imageEditButton.isHidden.toggle()
        memoTextView.isUserInteractionEnabled.toggle()
        
        if isEditable {
            memoTextView.becomeFirstResponder()
        }
        
        navigationItem.rightBarButtonItem = setNavigationRightButton(isEditable)
    }
    
    private func saveMealData() {
        if imageView.image == UIImage(named: "FoodBasicImage") && memoTextView.text == "" {
            showAlertOneButton(title: "", message: "한 가지 영역은 입력해 주세요")
            return
        }
        let newMeal = createMealData()
        manager.addMeal(newMeal)
    }
    
    private func updateMealData() {
        guard let mealData = mealData, let imagePath = mealData.imagePath else { return }
        let newMeal = createMealData()
        manager.updateMeal(mealData, newMeal: newMeal)
        ImageFileManager.shared.removeImage(with: imagePath)
    }
    
    private func removeMealData() {
        guard let mealData = self.mealData, let imagePath = mealData.imagePath else { return }
        manager.deleteMeal(mealData)
        ImageFileManager.shared.removeImage(with: imagePath)
        self.showAlertOneButton(title: "", message: "삭제했습니다") {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - @objc 메서드

extension MealEditViewController {
    
    @objc func displayDatePickerView() {
        let alert = UIAlertController(title: nil, message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(datePickerView)

        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.locale = Locale(identifier: "ko_KR")
        datePickerView.timeZone = TimeZone(identifier: "ko_KR")
        
        datePickerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let text = DateFormatter.toString(from: self.datePickerView.date)
            self.dateLabel.text = "\(text) ▽"
            self.selectedDate = self.datePickerView.date
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func didTappedRigthButton() {
        if mealId == nil {
            saveMealData()
        } else {
            updateMealData()
        }

        showAlertOneButton(title: "", message: "식단 저장 완료했습니다") {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func displayActionSheet() {
        showActionSheet(modifyCompletion: {
            self.isEditable = true
        }, removeCompletion: {
            self.removeMealData()
        })
    }
    
    @objc func openPhotoLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
}

// MARK: - Image PickerView
extension MealEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    guard let selectedImage = image as? UIImage else { return }
                    self.imageView.image = selectedImage
                }
            }
        }
    }
}
