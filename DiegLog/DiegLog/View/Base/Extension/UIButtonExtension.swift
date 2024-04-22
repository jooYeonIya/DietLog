//
//  UIButtonExtension.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

extension UIButton {
    func setupButton(title: String, titleSize : UIFont) {
        layer.cornerRadius = 22
        layer.masksToBounds = true
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        
        self.titleLabel?.setupLabel(text: title, font: .subTitle)
        
        backgroundColor = .customYellow
    }
    
    func setupFloatingButton(isUsedPlusSymbol: Bool = true) {
        layer.cornerRadius = 26
        backgroundColor = .customGreen
        
        if isUsedPlusSymbol {
            let buttonImage = UIImage(systemName: "plus",
                                      withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
            setImage(buttonImage, for: .normal)
            tintColor = .white
        } else {
            setTitle("저장", for: .normal)
            setTitleColor(.white, for: .normal)
            titleLabel?.font = .smallBody
        }

        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
}
