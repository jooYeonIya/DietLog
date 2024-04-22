//
//  UIColorExtension.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/22.
//

import UIKit

extension UIColor {
    
    static var customYellow: UIColor {
        guard let color = UIColor(named: "customYellow") else {
            return .systemYellow }
        return color
    }
    
    static var customGreen: UIColor {
        guard let color = UIColor(named: "customGreen") else {
            return .systemGreen }
        return color
    }
    
    static var customRightGreen: UIColor {
        guard let color = UIColor(named: "customRightGreen") else {
            return .systemGreen }
        return color
    }
    
    static var customGray: UIColor {
        guard let color = UIColor(named: "customGray") else {
            return .systemGray }
        return color
    }
}
