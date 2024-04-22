//
//  MealListTableViewCell.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit

class MealsDataTableViewCell: UITableViewCell {

    func configure(with imagePath: String) {
        
        let mealDataImage = ImageFileManager.shared.loadImage(with: imagePath) ?? UIImage(named: "FoodBasicImage")
        
        let imageView = UIImageView()
        imageView.image = mealDataImage
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.customGray.cgColor
        imageView.layer.borderWidth = 1.0
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
    }
}
