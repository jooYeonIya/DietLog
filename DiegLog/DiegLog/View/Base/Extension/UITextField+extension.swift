//
//  UITextField+extension.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

extension UITextField {
    func setupTextField(){
        self.layer.cornerRadius = 22
        self.layer.masksToBounds = true
        
        self.layer.borderWidth = 1.2
        self.layer.borderColor = UIColor.customYellow.cgColor
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
    }
}
