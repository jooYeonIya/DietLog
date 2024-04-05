//
//  ExerciseCollectionViewCell.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit

class ExerciseCollectionViewCell: UICollectionViewCell {
    
    func configure(text: String) {
        let view = UIView()
        view.backgroundColor = .systemCyan
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let label = UILabel()
        label.setupLabel(text: text, font: .smallBody)
        label.textAlignment = .center
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        
        view.addSubViews([label, button])
        
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(12)
            make.top.equalTo(button.snp.bottom)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(20)
        }
    }
}
