//
//  MealViewController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit
import FSCalendar

class MealViewController: BaseUIViewController {
    
    // MARK: - Component
    private lazy var calendarView = FSCalendar()
    private lazy var mealListTebleView = UITableView()
    private lazy var floatingButton = UIButton()
    private lazy var noDataLabel = UILabel()
    
    // MARK: - 변수
    private var mealList: [UIImage] = [UIImage(named: "testImege")!]
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup
    override func setUI() {
        setCalendarViewUI()
        setTableViewUI()
        setButtonUI()
        
        noDataLabel.setupLabel(text: "데이터를 기록해 주세요", font: .body)
        noDataLabel.isHidden = mealList.count == 0 ? false : true
        view.addSubview(noDataLabel)
    }
    
    override func setLayout() {
        setCalendarViewLayout()
        setTableViewLayout()
        setButtonLayout()
        
        noDataLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(calendarView.snp.bottom).offset(8)
        }
 }
    
    override func setDelegate() {
        setCalendarViewDelegate()
        setTableViewDelegate()
    }
    
    func setButtonUI() {
        floatingButton.layer.cornerRadius = 30
        floatingButton.backgroundColor = .systemBlue
        
        let buttonImage = UIImage(systemName: "plus",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        floatingButton.setImage(buttonImage, for: .normal)
        floatingButton.tintColor = .white
        
        floatingButton.layer.shadowRadius = 4
        floatingButton.layer.shadowOpacity = 0.4
        
        view.addSubview(floatingButton)
    }
    
    func setButtonLayout() {
        floatingButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.width.equalTo(60)
        }
    }
}

// MARK: - FSCalendar
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

// MARK: - TableView
extension MealViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableViewUI() {
        mealListTebleView.isHidden = mealList.count == 0 ? true : false
        mealListTebleView.register(MealListTableViewCell.self, forCellReuseIdentifier: "MealListTableViewCell")
        view.addSubview(mealListTebleView)
    }
    
    func setTableViewLayout() {
        mealListTebleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(calendarView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(calendarView)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setTableViewDelegate() {
        mealListTebleView.delegate = self
        mealListTebleView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealList.count == 0 ? 0 : mealList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealListTableViewCell", for: indexPath) as? MealListTableViewCell else { return UITableViewCell() }
        cell.mealImageView.image = mealList[indexPath.row]
        cell.configre()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
