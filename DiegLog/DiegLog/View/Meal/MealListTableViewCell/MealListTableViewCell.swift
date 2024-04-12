//
//  MealListTableViewCell.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit

class MealListTableViewCell: UITableViewCell {

    var mealImageView = UIImageView()
    
    func configre(with imageName: String) {

        mealImageView.image = UIImage(systemName: imageName)
        
        mealImageView.contentMode = .scaleAspectFill
        mealImageView.layer.cornerRadius = 12
        mealImageView.layer.masksToBounds = true
        contentView.addSubview(mealImageView)
        
        mealImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
