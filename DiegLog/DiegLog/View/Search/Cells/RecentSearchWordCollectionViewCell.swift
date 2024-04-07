//
//  recentSearchWordCollectionViewCell.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/07.
//

import UIKit

class RecentSearchWordCollectionViewCell: UICollectionViewCell {
    
    lazy var recentSearchWordlabel = UILabel()

    func configure(with text: String) {
        recentSearchWordlabel.setupLabel(text: text, font: .smallBody)
        
        contentView.addSubview(recentSearchWordlabel)
        
        recentSearchWordlabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 1.0
    }
}
