//
//  MealViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit
import FSCalendar

class MealViewController: BaseUIViewController {
    
    private lazy var calendarView = FSCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        setCalendarViewUI()
    }
    
    override func setLayout() {
        setCalendarViewLayout()
    }
    
    override func setDelegate() {
        setCalendarViewDelegate()
    }
}

extension MealViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func setCalendarViewUI() {
        calendarView.configure()
        view.addSubview(calendarView)
    }
    
    func setCalendarViewLayout() {
        calendarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(-(navigationController?.navigationBar.frame.size.height)!)
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
    
    // 이벤트 갯수 설정
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
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
