//
//  recentSearchWordCollectionViewCell.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/07.
//

import UIKit

protocol RecentSearchWordCollectionViewCellDelegate: AnyObject {
    func didTappedDelegateButton()
}

class RecentSearchWordCollectionViewCell: UICollectionViewCell {
    
    lazy var recentSearchWordlabel = UILabel()
    lazy var deleteButton = UIButton()
    
    weak var delegate: RecentSearchWordCollectionViewCellDelegate?
    
    static let identifier = "RecentSearchWordCollectionViewCell"

    func configure(with text: String) {
        recentSearchWordlabel.setupLabel(text: text, font: .smallBody)
        recentSearchWordlabel.textColor = .white
        
        deleteButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12)), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.addTarget(self, action: #selector(deleteSearch(_:)), for: .touchUpInside)
        
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
        contentView.backgroundColor = .customGreen
    }
    
    @objc func deleteSearch(_ sender: UIButton) {
        RecentSearchManager.shared.deleteSearch(at: sender.tag)
        delegate?.didTappedDelegateButton()
    }
}
