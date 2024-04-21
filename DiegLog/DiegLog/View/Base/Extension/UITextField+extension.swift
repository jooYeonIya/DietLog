//
//  UITextField+extension.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

extension UITextField {
    func setupTextField(){
        font = .body
        
        layer.cornerRadius = 22
        layer.masksToBounds = true
        
        layer.borderWidth = 1.2
        layer.borderColor = UIColor.customYellow.cgColor
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        leftView = leftPaddingView
        leftViewMode = .always
    }
}
