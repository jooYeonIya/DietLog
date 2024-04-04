//
//  UIFontExtension.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

extension UIFont {
    class var largeTitle: UIFont {
        return UIFont.boldSystemFont(ofSize: 30)
    }
    
    class var title: UIFont {
        return UIFont.boldSystemFont(ofSize: 26)
    }
    
    class var subTitle: UIFont {
        return UIFont.systemFont(ofSize: 22)
    }
    
    class var body: UIFont {
        return UIFont.systemFont(ofSize: 18)
    }
    
    class var smallBody: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
}
