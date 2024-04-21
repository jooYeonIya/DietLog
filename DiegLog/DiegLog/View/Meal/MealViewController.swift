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
    private lazy var topView = UIView()
    private lazy var calendarView = FSCalendar()
    private lazy var mealsDataTableView = UITableView()
    private lazy var floatingButton = UIButton()
    private lazy var noDataLabel = UILabel()
    
    // MARK: - 변수
    private var manager = MealManager.shared
    private var selectedDate: Date = Date.now
    private var mealsData: [Meal] = [] {
        didSet {
            let hasData = !mealsData.isEmpty
            noDataLabel.isHidden = hasData
            mealsDataTableView.isHidden = !hasData
            mealsDataTableView.reloadData()
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadMealsData()
    }
    
    // MARK: - Setup UI
    override func setUI() {
        setTopViewUI()
        setCalendarViewUI()
        setTableViewUI()
        setFloatingButtonUI()
        setNoDataLabelUI()
    }
    
    private func setTopViewUI() {
        topView.backgroundColor = .customYellow
        view.addSubview(topView)
    }
    
    private func setCalendarViewUI() {
        calendarView.configure()
        view.addSubview(calendarView)
    }
    
    private func setTableViewUI() {
        mealsDataTableView.showsVerticalScrollIndicator = false
        mealsDataTableView.separatorStyle = .none
        mealsDataTableView.register(MealsDataTableViewCell.self, forCellReuseIdentifier: "MealListTableViewCell")
        view.addSubview(mealsDataTableView)
    }
    
    private func setFloatingButtonUI() {
        floatingButton.setupFloatingButton()
        view.addSubview(floatingButton)
    }
    
    private func setNoDataLabelUI() {
        noDataLabel.setupLabel(text: "데이터를 기록해 주세요", font: .body)
        view.addSubview(noDataLabel)
    }
    
    // MARK: - Setup Layout
    override func setLayout() {
        setTopViewLayout()
        setCalendarViewLayout()
        setTableViewLayout()
        setFloatingButtonLayout()
        setNoDataLabelLayout()
    }
    
    private func setTopViewLayout() {
        topView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(140)
        }
    }
    
    private func setCalendarViewLayout() {
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(360)
        }
    }
    
    private func setTableViewLayout() {
        mealsDataTableView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.leading.trailing.equalTo(calendarView)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setFloatingButtonLayout() {
        floatingButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.width.equalTo(52)
        }
    }

    private func setNoDataLabelLayout() {
        noDataLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(calendarView.snp.bottom).offset(8)
        }
    }
    
    // MARK: - Setup Delegate
    override func setDelegate() {
        setCalendarViewDelegate()
        setTableViewDelegate()
    }
    
    private func setCalendarViewDelegate() {
        calendarView.dataSource = self
        calendarView.delegate = self
    }
    
    private func setTableViewDelegate() {
        mealsDataTableView.delegate = self
        mealsDataTableView.dataSource = self
    }
    
    // MARK: - Setup AddTarget
    override func setAddTartget() {
        floatingButton.addTarget(self, action: #selector(didTappedFloatingButton), for: .touchUpInside)
    }
}

// MARK: - 메서드
extension MealViewController {
    
    private func reloadMealsData() {
        if let result = manager.getMeals(for: selectedDate) {
            mealsData = Array(result)
        }
    }
}

// MARK: - @objc 메서드
extension MealViewController {
    
    @objc func didTappedFloatingButton() {
        let vc = MealEditViewController(mealId: nil, selectedDate: selectedDate)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - FSCalendar
extension MealViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealListTableViewCell", for: indexPath) as? MealsDataTableViewCell else { return UITableViewCell() }

        guard let imagePath = mealsData[indexPath.row].imagePath else { return cell }

        cell.configure(with: imagePath)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mealId = mealsData[indexPath.row].id
        let vc = MealEditViewController(mealId: mealId, selectedDate: selectedDate)
        navigationController?.pushViewController(vc, animated: true)
    }
}
