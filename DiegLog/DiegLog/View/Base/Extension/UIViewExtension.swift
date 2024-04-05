//
//  UIViewExtension.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        views.forEach({
            self.addSubview($0)
        })
    }
}
