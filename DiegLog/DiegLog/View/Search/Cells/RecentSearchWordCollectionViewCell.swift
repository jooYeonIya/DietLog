//
//  recentSearchWordCollectionViewCell.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/07.
//

import UIKit

class RecentSearchWordCollectionViewCell: UICollectionViewCell {
    
    lazy var recentSearchWordlabel = UILabel()
    lazy var deleteButton = UIButton()

    func configure(with text: String) {
        recentSearchWordlabel.setupLabel(text: text, font: .smallBody)
        
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .black
        
        contentView.addSubViews([recentSearchWordlabel, deleteButton])
        
        recentSearchWordlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.lessThanOrEqualTo(recentSearchWordlabel.snp.trailing).inset(4)
            make.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(24)
        }
        
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 1.0
    }
}
