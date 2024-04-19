//
//  ExerciseDetailTableViewCell.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/05.
//

import UIKit

protocol ExerciseTableViewCellDelegate: AnyObject {
    func didTappedOptionButton(_ cell: ExerciseTableViewCell)
}

class ExerciseTableViewCell: UITableViewCell {
    
    private lazy var thumbnailImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var optionButton = UIButton()
    
    weak var delegate: ExerciseTableViewCellDelegate?
    
    static let identifier = "ExerciseTableViewCell"
    
    var exercise: Exercise?
    
    func configure(with exercise: Exercise) {
        self.exercise = exercise
        
        setImageView()
        setTitleLabel()
        setOptionButton()

        contentView.addSubViews([thumbnailImageView, titleLabel, optionButton])
        
        setLayout()
    }
    
    private func setImageView() {
        guard let exercise = exercise else { return }
        
        YoutubeAPIManager.shared.getThumbnailImage(with: exercise.thumbnailURL) { image in
            DispatchQueue.main.async {
                if let thumbnailImage = image {
                    self.thumbnailImageView.image = thumbnailImage
                } else {
                    // 에러 처리, 예를 들어 기본 이미지 설정
                }
            }
        }
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 12
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.layer.borderColor = UIColor.gray.cgColor
        thumbnailImageView.layer.borderWidth = 0.5
    }
    
    private func setTitleLabel() {
        guard let exercise = exercise else { return }
        
        titleLabel.setupLabel(text: exercise.title, font: .smallBody)
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.numberOfLines = 0
    }
    
    private func setOptionButton() {
        optionButton.setImage(UIImage(systemName: "photo"), for: .normal)
        optionButton.addTarget(self, action: #selector(didTappedOptionButton), for: .touchUpInside)
    }
    
    private func setLayout() {
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
    
    @objc func didTappedOptionButton() {
        delegate?.didTappedOptionButton(self)
    }
}
