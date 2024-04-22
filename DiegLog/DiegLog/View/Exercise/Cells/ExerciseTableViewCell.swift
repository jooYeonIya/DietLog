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
    
    private lazy var shadowView = UIView()
    private lazy var thumbnailImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var optionButton = UIButton()
    
    weak var delegate: ExerciseTableViewCellDelegate?
    
    static let identifier = "ExerciseTableViewCell"
    
    var exercise: Exercise?
    
    func configure(with exercise: Exercise) {
        self.exercise = exercise
        
        setShadowView()
        setImageView()
        setTitleLabel()
        setOptionButton()

        contentView.addSubViews([shadowView, thumbnailImageView, titleLabel, optionButton])
        
        setLayout()
    }
    
    private func setShadowView() {
        shadowView.backgroundColor = .customYellow
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 2
        shadowView.layer.cornerRadius = 12
    }
    
    private func setImageView() {
        guard let exercise = exercise else { return }
        
        YoutubeAPIService.shared.getThumbnailImage(with: exercise.thumbnailURL) { image in
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
        
        titleLabel.setupLabel(text: exercise.title, font: .body)
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.numberOfLines = 0
    }
    
    private func setOptionButton() {
        optionButton.setImage(UIImage(named: "OptionMenu"), for: .normal)
        optionButton.addTarget(self, action: #selector(didTappedOptionButton), for: .touchUpInside)
    }
    
    private func setLayout() {
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.trailing.equalTo(shadowView).inset(12)
            make.height.equalTo(thumbnailImageView.snp.width).dividedBy(2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            make.leading.equalTo(thumbnailImageView.snp.leading).inset(8)
            make.trailing.equalTo(optionButton.snp.leading)
            make.bottom.equalToSuperview().inset(12)
        }

        optionButton.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            make.trailing.equalTo(thumbnailImageView.snp.trailing).inset(8)
            make.width.height.equalTo(20)
        }
    }
    
    @objc func didTappedOptionButton() {
        delegate?.didTappedOptionButton(self)
    }
}
