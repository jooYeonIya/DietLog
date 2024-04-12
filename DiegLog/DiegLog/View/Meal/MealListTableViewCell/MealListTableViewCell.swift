//
//  MealListTableViewCell.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit

class MealListTableViewCell: UITableViewCell {

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

    func loadImageFromDocumentDirectory(with imagePath: String) -> UIImage? {
        // 1. 도큐먼트 디렉토리 경로 확인
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        // 2. 폴더 경로, 이미지 경로 찾기
        let imageURL = documentDirectory.appendingPathComponent(imagePath)

        // 3. UIImage로 불러오기
        return UIImage(contentsOfFile: imageURL.path)
    }
}
