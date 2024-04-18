//
//  MealListTableViewCell.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit

class MealsDataTableViewCell: UITableViewCell {

    var mealImageView = UIImageView()
    
    func configre(with imagePath: String) {
        
        let mealDataImage = loadImageFromDocumentDirectory(with: imagePath) ?? UIImage(named: "FoodBasicImage")
        
        mealImageView.image = mealDataImage
        
        mealImageView.contentMode = .scaleAspectFill
        mealImageView.layer.cornerRadius = 12
        mealImageView.layer.masksToBounds = true
        contentView.addSubview(mealImageView)
        
        mealImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
    }

    func loadImageFromDocumentDirectory(with imagePath: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let imageURL = documentDirectory.appendingPathComponent(imagePath)

        return UIImage(contentsOfFile: imageURL.path)
    }
}
