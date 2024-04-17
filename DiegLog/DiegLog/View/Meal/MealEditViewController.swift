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
    
    private lazy var dateLabel = UILabel()
    private lazy var datePickerView = UIDatePicker()
    private lazy var imageLabel = UILabel()
    private lazy var imageView = UIImageView()
    private lazy var imageEditButton = UIButton()
    private lazy var memoLabel = UILabel()
    private lazy var memoTextView = UITextView()
    
    var seletedDate: Date
    let mealId: ObjectId?
    var mealData: Meal? {
        didSet {
            imageView.image = loadImageFromDocumentDirectory(with: (mealData?.imagePath)!)
            memoTextView.text = mealData?.memo
        }
    }
    
    init(mealId: ObjectId?, seletedDate: Date) {
        self.mealId = mealId
        self.seletedDate = seletedDate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = mealId {
            mealData = Meal.getMeal(for: id)
        }
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
        
        if mealId == nil {
            rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveMealData))
        } else {
            rightButton = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(displayActionSheet))
        }
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func setDateLabelUI() {
        let text = DateFormatter.toString(from: seletedDate)
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
        imageView.image = UIImage(named: "FoodBasicImage")
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        
        imageEditButton.setImage(UIImage(systemName: "plus"), for: .normal)
        imageEditButton.backgroundColor = .white
        imageEditButton.layer.cornerRadius = 20
        imageEditButton.layer.shadowRadius = 4
        imageEditButton.layer.shadowOpacity = 0.4
        
        imageEditButton.addTarget(self, action: #selector(openPhotoLibrary), for: .touchUpInside)

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
    
    @objc func saveMealData() {
                
        if imageView.image == UIImage(named: "FoodBasicImage") && memoTextView.text == "" {
            showAlertOneButton(title: "", message: "한 가지 영역은 입력해 주세요")
            return
        }
        
        let meal = returnMealData()
        Meal.addMeal(meal)
        
        showAlertOneButton(title: "", message: "식단 저장 완료했습니다") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func returnMealData() -> Meal {
        let meal = Meal()
        
        if let folderName = dateLabel.text, let image = imageView.image {
            
            let imageName = UUID().uuidString
            saveImageToDocumentDirectory(folderName: folderName, imageName: "\(imageName).png", image: image)
            
            meal.folderName = folderName
            meal.imageName = imageName
            meal.memo = memoTextView.text
            meal.postedDate = seletedDate
        }
        
        return meal
    }
    
    @objc func displayActionSheet() {
        guard let mealData = mealData, let imagePath = mealData.imagePath else { return }
        
        showActionSheet(modifyCompletion: {
            let newMeal = self.returnMealData()
            Meal.updateMeal(mealData, newMeal: newMeal)
            self.removeImageFromDocumentDirectory(with: imagePath)
            self.showAlertOneButton(title: "", message: "수정했습니다") {
                self.navigationController?.popViewController(animated: true)
            }
        }, removeCompletion: {
            Meal.deleteMeal(mealData)
            self.removeImageFromDocumentDirectory(with: imagePath)
            self.showAlertOneButton(title: "", message: "삭제했습니다") {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    @objc func loadImageFromDocumentDirectory(with imagePath: String) -> UIImage? {
        // 1. 도큐먼트 디렉토리 경로 확인
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        // 2. 폴더 경로, 이미지 경로 찾기
        let imageURL = documentDirectory.appendingPathComponent(imagePath)

        // 3. UIImage로 불러오기
        return UIImage(contentsOfFile: imageURL.path)
    }
    
    func removeImageFromDocumentDirectory(with imagePath: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let imageURL = documentDirectory.appendingPathComponent(imagePath)


        do {
            try FileManager.default.removeItem(at: imageURL)
            print("File removed successfully.")
        } catch {
            print("Error removing file: \(error)")
        }
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
    
    func saveImageToDocumentDirectory(folderName: String, imageName: String, image: UIImage) {
        // 1. 도큐먼트 디렉토리 경로 확인
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        // 2. 폴더 경로 설정
        let folderURL = documentDirectory.appendingPathComponent(folderName)
        
        // 2-1. 폴더가 없다면 생성
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("폴더 생성 실패 \(error)")
            }
        }
        
        // 3. 이미지 경로 설정
        let imageURL = folderURL.appendingPathComponent(imageName)

        // 4. 이미지 압축(image.pngData())
        guard let imageData = image.pngData() else {
            print("이미지 압축 실패")
            return
        }

        // 5. 이미지를 도큐먼트에 저장
        do {
            try imageData.write(to: imageURL, options: [.atomic])
            print("이미지 저장 완료")
        } catch {
            print("이미지 저장 실패 \(error)")
        }
    }
}
