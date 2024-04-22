//
//  AppTabBarItem.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

enum AppTabBarItem: Int {
    
    case meal, myInfo, exercise, search
    
    func toTabTitle() -> String {
        switch self {
        case .meal: return "식단"
        case .myInfo: return "내 정보"
        case .exercise: return "운동"
        case .search: return "검색"    
        }
    }
    
    // 이미지는 추후 수정
    func toTabImage() -> UIImage {
        switch self {
        case .meal: return UIImage(named: "Meal") ?? UIImage()
        case .myInfo: return UIImage(named: "MyInfo") ?? UIImage()
        case .exercise: return UIImage(named: "Exercise") ?? UIImage()
        case .search: return UIImage(named: "Search") ?? UIImage()
        }
    }
}
