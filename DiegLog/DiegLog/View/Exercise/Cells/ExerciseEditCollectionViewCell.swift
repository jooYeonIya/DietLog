//
//  ExerciseDetailEditCollectionViewCell.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/06.
//

import UIKit

class ExerciseEditCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ExerciseEditCollectionViewCell"
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? UIColor.customRightGreen.cgColor : UIColor.customYellow.cgColor
            contentView.layer.borderWidth = isSelected ? 1.5 : 1.2
        }
    }
    
    func configure(text: String) {
        let label = UILabel()
        label.setupLabel(text: text, font: .smallBody)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.textAlignment = .center
        
        contentView.layer.cornerRadius = 24
        contentView.layer.masksToBounds = true
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(12)
            make.height.equalToSuperview()
        }
    }
}
