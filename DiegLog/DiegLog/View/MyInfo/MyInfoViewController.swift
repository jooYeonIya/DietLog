//
//  MyInfoViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit
import FSCalendar

class MyInfoViewController: BaseUIViewController {
    
    private lazy var nickNameLabel = UILabel()
    private lazy var calendarView = FSCalendar()
    private lazy var editButton = UIButton()
    private lazy var weightTextField = UITextField()
    private lazy var muscleTextField = UITextField()
    private lazy var fatTextField = UITextField()

    let myInfo: [String] = ["100", "100", "100"]
    var postedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isFirstLaunch = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isFirstLaunch)
        
        if !isFirstLaunch {
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isFirstLaunch)
        }
    }
    
    override func setUI() {
        if let nickName = UserDefaults.standard.string(forKey: UserDefaultsKeys.nickName) {
            setNickNameLabelUI(nickName)
        }
        
        setCalendarViewUI()
        setStackView()
        setEditButtonUI()
    }
    
    override func setLayout() {
        setNickNameLabelLayot()
        setCalendarViewLayout()
        setEditButtonLayout()
    }
    
    override func setDelegate() {
        setCalendarViewDelegate()
    }
    
    func setNickNameLabelUI(_ nickName: String) {
        nickNameLabel.setupLabel(text: "안녕하세요 \(nickName)", font: .largeTitle)
        view.addSubview(nickNameLabel)
    }
    
    func setEditButtonUI() {
        let title = myInfo.count == 0 ? "저장" : "수정"
        editButton.setTitle(title, for: .normal)
        editButton.setTitleColor(.blue, for: .normal)
        editButton.addTarget(self, action: #selector(editMyInfo), for: .touchUpInside)
        
        view.addSubview(editButton)
    }

    func setNickNameLabelLayot() {
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    func setEditButtonLayout() {
        editButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.width.equalTo(60)
        }
    }
}

extension MyInfoViewController {
    func setStackView() {
        
        let rowStackView = UIStackView()
        rowStackView.axis = .vertical
        rowStackView.distribution = .fillEqually
        rowStackView.spacing = 24

        let title = ["몸무게", "골격근량", "체지방량"]
        let textFields = [weightTextField, muscleTextField, fatTextField]
        
        for i in 0..<title.count {
            
            let label1 = UILabel()
            label1.setupLabel(text: title[i], font: .body)
            
            let label2 = UILabel()
            label2.setupLabel(text: "kg", font: .body)
        
            if !myInfo.isEmpty {
                textFields[i].text = myInfo[i]
                textFields[i].isUserInteractionEnabled = false
            }
            
            textFields[i].setUpTextField()
            
            let columnStackView = UIStackView(arrangedSubviews: [label1, textFields[i], label2])
            columnStackView.axis = .horizontal
            columnStackView.distribution = .fillEqually
            columnStackView.spacing = 8
            
            rowStackView.addArrangedSubview(columnStackView)
        }

        view.addSubview(rowStackView)
        
        rowStackView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(nickNameLabel)
        }
    }
    
    @objc func editMyInfo() {
        print("editMyInfo")
        
        let title = editButton.titleLabel?.text
        
        if title == "수정" {
            editButton.setTitle("저장", for: .normal)
        } else {
            view.endEditing(true)
            editButton.setTitle("수정", for: .normal)
            saveMyInfo()
        }
        
        weightTextField.isUserInteractionEnabled.toggle()
        muscleTextField.isUserInteractionEnabled.toggle()
        fatTextField.isUserInteractionEnabled.toggle()
    }
    
    func saveMyInfo() {
        let textFields = [weightTextField, muscleTextField, fatTextField]
        
        let checkValid = textFields.contains {
            guard let text = $0.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
                return false
            }
            
            return Int(text) != nil
        }
        
        if !checkValid {
            showAlertOneButton(title: "", message: "최소 하나의 영역에 숫자를 입력해야 합니다")
        }
        
        let myInfo = MyInfo()
        myInfo.postedDate = postedDate
        myInfo.weight = Int(weightTextField.text!)
        myInfo.muscle = Int(muscleTextField.text!)
        myInfo.fat = Int(fatTextField.text!)
        
        MyInfo.addMyInfo(myInfo)
        
        showAlertOneButton(title: "", message: "저장했습니다")
    }
}

extension MyInfoViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func setCalendarViewUI() {
        calendarView.configure()
        view.addSubview(calendarView)
    }
    
    func setCalendarViewLayout() {
        calendarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nickNameLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(300)
        }
    }
    
    func setCalendarViewDelegate() {
        calendarView.dataSource = self
        calendarView.delegate = self
    }
    
    // FSCalendar 내장 메소드
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        
        self.view.layoutIfNeeded()
    }
    
    // 날짜 선택했을 때
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
    // 날짜 선택 해제했을 때
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
    // 토, 일 색깔 다르게 설정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .systemRed
        } else if Calendar.current.shortWeekdaySymbols[day] == "토" {
            return .systemBlue
        } else {
            return .label
        }
    }
    
    // 오늘 날짜 밑에 글씨 추가
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
            return "오늘"
        } else {
            return ""
        }
    }
}
