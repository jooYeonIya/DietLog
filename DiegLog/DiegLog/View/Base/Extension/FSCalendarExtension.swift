//
//  FSCalendarExtension.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import FSCalendar

extension FSCalendar {
    func configure() {
        // 주간, 월간
        self.scope = .month
        
        // 스크롤
        self.scrollEnabled = true
        self.scrollDirection = .horizontal
        
        // 헤더
        self.appearance.headerTitleFont = .subTitle
        self.appearance.headerDateFormat = "YYYY년 MM월"
        self.appearance.headerTitleColor = .black
        self.appearance.headerTitleAlignment = .center
        self.appearance.headerMinimumDissolvedAlpha = 0.0
        self.appearance.headerTitleOffset = CGPoint(x: 0, y: -16)
        
        self.headerHeight = 60
        
        // 서브타이틀
        self.appearance.subtitleTodayColor = .customRightGreen
        self.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        self.appearance.subtitleFont = UIFont(name: FontName.regular, size: 8)
        
        // 요일
        // 요일 언어 변경, 지역화
        self.locale = Locale(identifier: "ko_KR")
        
        // 일요일 1, 월요일 2
        self.firstWeekday = 1
        self.weekdayHeight = 12
 
        self.appearance.weekdayFont = .smallBody
        self.appearance.weekdayTextColor = .systemGray
        
        // 날짜
        self.appearance.titleFont = .body
       
        // 오늘 날짜 선택 표시
        self.appearance.todayColor = .clear
        self.appearance.titleTodayColor = .black
        
        // 지난 달, 다음 달 안 보이게 처리
        self.placeholderType = .none
        
        // 선택 날짜 색깔
        self.appearance.selectionColor = .customYellow
    }
}
