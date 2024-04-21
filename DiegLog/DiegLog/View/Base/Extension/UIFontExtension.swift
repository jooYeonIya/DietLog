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
        guard let font = UIFont(name: FontName.bold, size: 30) else {
            return UIFont.boldSystemFont(ofSize: 30)
        }
        return font
    }
    
    class var title: UIFont {
        guard let font = UIFont(name: FontName.bold, size: 26) else {
            return UIFont.boldSystemFont(ofSize: 26)
        }
        return font
    }
    
    class var subTitle: UIFont {
        guard let font = UIFont(name: FontName.regular, size: 22) else {
            return UIFont.systemFont(ofSize: 22)
        }
        return font
    }
    
    class var body: UIFont {
        guard let font = UIFont(name: FontName.regular, size: 18) else {
            return UIFont.systemFont(ofSize: 18)
        }
        return font
    }
    
    class var smallBody: UIFont {
        guard let font = UIFont(name: FontName.regular, size: 14) else {
            return UIFont.systemFont(ofSize: 14)
        }
        return font
    }
}
