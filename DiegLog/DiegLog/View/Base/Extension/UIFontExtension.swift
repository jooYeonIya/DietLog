//
//  UIFontExtension.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

struct FontName {
    static let bold = "LINESeedSansKR-Bold"
    static let regular = "LINESeedSansKR-Regular"
}

extension UIFont {
    class var largeTitle: UIFont {
        guard let font = UIFont(name: FontName.bold, size: 28) else {
            return UIFont.boldSystemFont(ofSize: 28)
        }
        return font
    }
    
    class var title: UIFont {
        guard let font = UIFont(name: FontName.bold, size: 24) else {
            return UIFont.boldSystemFont(ofSize: 24)
        }
        return font
    }
    
    class var subTitle: UIFont {
        guard let font = UIFont(name: FontName.bold, size: 20) else {
            return UIFont.boldSystemFont(ofSize: 20)
        }
        return font
    }
    
    class var body: UIFont {
        guard let font = UIFont(name: FontName.regular, size: 16) else {
            return UIFont.systemFont(ofSize: 16)
        }
        return font
    }
    
    class var smallBody: UIFont {
        guard let font = UIFont(name: FontName.regular, size: 12) else {
            return UIFont.systemFont(ofSize: 12)
        }
        return font
    }
}
