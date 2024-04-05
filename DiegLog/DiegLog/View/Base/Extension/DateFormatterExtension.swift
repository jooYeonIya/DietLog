//
//  DateFormatterExtension.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import Foundation

extension DateFormatter {
    static func toString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
}
