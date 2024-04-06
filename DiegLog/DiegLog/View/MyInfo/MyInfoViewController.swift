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
    
    let nickName = "닉네임"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        setNickNameLabelUI()
        setCalendarViewUI()
        setStackView()
    }
    
    override func setLayout() {
        setNickNameLabelLayot()
        setCalendarViewLayout()
    }
    
    override func setDelegate() {
        setCalendarViewDelegate()
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

extension MyInfoViewController {
    func setStackView() {
        
        let columnStackView = UIStackView()
        columnStackView.axis = .vertical
        columnStackView.distribution = .fillEqually
        columnStackView.spacing = 24
        
        ["몸무게", "골격근량", "체지방량"].forEach({
            let label = UILabel()
            label.setupLabel(text: $0, font: .body)
            label.textAlignment = .center
            
            let textField = UITextField()
            textField.setUpTextField()
            
            let label2 = UILabel()
            label2.setupLabel(text: "kg", font: .body)
            
            let rowStackView = UIStackView(arrangedSubviews: [label, textField, label2])
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 4
            
            textField.snp.makeConstraints { make in
                make.height.equalTo(28)
            }
            
            columnStackView.addArrangedSubview(rowStackView)
        })

        view.addSubview(columnStackView)
        
        columnStackView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(nickNameLabel)
        }
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
