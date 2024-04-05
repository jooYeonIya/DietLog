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
        self.appearance.headerTitleFont = .systemFont(ofSize: 16)
        self.appearance.headerDateFormat = "YYYY년 MM월"
        self.appearance.headerTitleColor = .black
        self.appearance.headerTitleAlignment = .center
        self.appearance.headerMinimumDissolvedAlpha = 0.0
        
        self.headerHeight = 60
        
        // 서브타이틀
        self.appearance.subtitleTodayColor = .blue
        self.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        
        // 요일
        // 요일 언어 변경, 지역화
        self.locale = Locale(identifier: "ko_KR")
        
        // 일요일 1, 월요일 2
        self.firstWeekday = 1
        self.weekdayHeight = 10
 
        self.appearance.weekdayFont = .systemFont(ofSize: 12)
        self.appearance.weekdayTextColor = .systemGray
        
        // 날짜
        self.appearance.titleFont = .systemFont(ofSize: 16)
       
        // 오늘 날짜 선택 표시
        self.appearance.todayColor = .clear
        
        // 평일, 주말 색깔 선택
//        self.appearance.titleDefaultColor = .black
//        self.appearance.titleWeekendColor = .red
        
        //이벤트 색깔
        self.appearance.eventDefaultColor = UIColor.green
        self.appearance.eventSelectionColor = UIColor.green
        
        // 지난 달, 다음 달 안 보이게 처리
        self.placeholderType = .none
    }
}
