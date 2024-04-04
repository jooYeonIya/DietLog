//
//  UIButtonExtension.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

extension UIButton {
    func setUpButton(title: String, titleSize : UIFont) {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        
        backgroundColor = .systemBlue
        
        frame.size.height = 40
    }
}
