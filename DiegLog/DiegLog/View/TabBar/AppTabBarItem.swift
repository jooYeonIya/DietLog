//
//  AppTabBarItem.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

enum AppTabBarItem: Int {
    
    case meal, myInfo, exercise
    
    func toInt() -> Int {
        switch self {
        case .meal: return 0
        case .myInfo: return 1
        case .exercise: return 2

        }
    }
    
    func toTabTitle() -> String {
        switch self {
        case .meal: return "식단"
        case .myInfo: return "내 정보"
        case .exercise: return "운동"
        }
    }
    
    // 이미지는 추후 수정
    func toTabImage() -> UIImage {
        switch self {
        case .meal: return UIImage(systemName: "tray") ?? UIImage()
        case .myInfo: return UIImage(systemName: "tray") ?? UIImage()
        case .exercise: return UIImage(systemName: "tray") ?? UIImage()
        }
    }
}
