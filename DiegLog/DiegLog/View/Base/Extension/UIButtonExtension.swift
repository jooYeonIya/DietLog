//
//  UIButtonExtension.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

extension UIButton {
    func setupButton(title: String, titleSize : UIFont) {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        
        backgroundColor = .systemBlue
        
        frame.size.height = 40
    }
    
    func setupFloatingButton() {
        layer.cornerRadius = 26
        backgroundColor = .customGreen
        
        let buttonImage = UIImage(systemName: "plus",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        setImage(buttonImage, for: .normal)
        tintColor = .white
        
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
}
