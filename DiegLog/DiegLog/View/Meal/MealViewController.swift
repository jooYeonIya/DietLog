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
    private lazy var mealsDataTableView = UITableView()
    private lazy var floatingButton = UIButton()
    private lazy var noDataLabel = UILabel()
    
    // MARK: - 변수
    private var mealsData: [Meal]? {
        didSet {
            let hasData = mealsData != nil && !mealsData!.isEmpty
            noDataLabel.isHidden = hasData
            mealsDataTableView.isHidden = !hasData
            mealsDataTableView.reloadData()
        }
    }
    
    var selectedDate: Date?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDate = Date.now
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadMealsData()
    }
    
    // MARK: - Setup
    override func setUI() {
        setCalendarViewUI()
        setTableViewUI()
        setButtonUI()
        
        noDataLabel.setupLabel(text: "데이터를 기록해 주세요", font: .body)
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
        floatingButton.setUpFloatingButton()
        floatingButton.addTarget(self, action: #selector(didTappedFloatingButton), for: .touchUpInside)
        view.addSubview(floatingButton)
    }
    
    func setButtonLayout() {
        floatingButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.width.equalTo(60)
        }
    }
    
    @objc func didTappedFloatingButton() {
        let vc = MealEditViewController(mealId: nil, selectedDate: selectedDate ?? Date())
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 메서드
extension MealViewController {
    
    private func reloadMealsData() {
        if let result = Meal.getMeals(for: selectedDate ?? Date()) {
            mealsData = Array(result)
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
    
    // 내장 메소드
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        reloadMealsData()
    }
    
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
        mealsDataTableView.showsVerticalScrollIndicator = false
        mealsDataTableView.separatorStyle = .none
        mealsDataTableView.register(MealsDataTableViewCell.self, forCellReuseIdentifier: "MealListTableViewCell")
        view.addSubview(mealsDataTableView)
    }
    
    func setTableViewLayout() {
        mealsDataTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(calendarView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(calendarView)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setTableViewDelegate() {
        mealsDataTableView.delegate = self
        mealsDataTableView.dataSource = self
    }
    
    
    // 내장 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealListTableViewCell", for: indexPath) as? MealsDataTableViewCell, let imagePath = mealsData?[indexPath.row].imagePath else { return UITableViewCell() }
        
        cell.configre(with: imagePath)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mealId = mealsData?[indexPath.row].id else { return }
        let vc = MealEditViewController(mealId: mealId, selectedDate: selectedDate ?? Date())
        navigationController?.pushViewController(vc, animated: true)
    }
}
