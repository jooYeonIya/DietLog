//
//  ExerciseDetailTableViewCell.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit

class ExerciseDetailTableViewCell: UITableViewCell {
    
    private lazy var thumbnailImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var optionButton = UIButton()
    
    // 모델 [스트링]은 임시
    func configure(with exercise: Exercise) {
        optionButton.setImage(UIImage(systemName: "photo"), for: .normal)
        
        setLabel(title: exercise.title)
        
        YoutubeAPIManager.shared.getThumbnailImage(with: exercise.thumbnailURL) { image in
            DispatchQueue.main.async {
                if let image = image {
                    self.setImageView(thumbnailImage: image)
                } else {
                    // 에러 처리, 예를 들어 기본 이미지 설정
                }
            }
        }

        contentView.addSubViews([thumbnailImageView, titleLabel, optionButton])
        
        setLayout()
    }
    
    func setImageView(thumbnailImage: UIImage) {
        thumbnailImageView.image = thumbnailImage
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 12
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.layer.borderColor = UIColor.gray.cgColor
        thumbnailImageView.layer.borderWidth = 0.5
    }
    
    func setLabel(title: String) {
        titleLabel.setupLabel(text: title, font: .smallBody)
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.numberOfLines = 0
    }
    
    func setLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
            make.height.equalTo(contentView.snp.height).offset(-16)
            make.width.equalTo(thumbnailImageView.snp.height).multipliedBy(2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            make.trailing.equalTo(optionButton.snp.leading)

        }
        
        optionButton.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView)
            make.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(20)
        }
    }
}
