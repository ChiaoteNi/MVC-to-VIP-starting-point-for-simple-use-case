//
//  HistoryMeetupEventCell.swift
//  ITApp
//
//  Created by Chiaote Ni on 2020/10/13.
//

import UIKit

final class HistoryMeetupEventCell: BaseCell {

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.dateLabel
        label.textColor = Constant.Color.dateLabel
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.titleLabel
        label.textColor = Constant.Color.titleLabel
        label.numberOfLines = Constant.NumberOfLine.common
        return label
    }()
    
    private let hostNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.hostNameLabel
        label.textColor = Constant.Color.hostNameLabel
        return label
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = Constant.Color.coverImageView
        return imageView
    }()
    
    private(set) lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(nil, for: .normal)
        button.setImage(Constant.Image.favoriteButton, for: .normal)
        
        button.addTarget(self,
                         action: #selector(handleFavoriteButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    var tapFavoriteCallBack: (() -> Void)?
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.layoutMarginsGuide)
            make.size.equalTo(Constant.Size.coverImage)
        }
        
        contentView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.layoutMarginsGuide)
            make.size.equalTo(Constant.Size.favoriteIcon)
        }
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            titleLabel,
            dateLabel,
            hostNameLabel
        ])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(coverImageView.snp.height)
            make.top.bottom.equalTo(contentView.layoutMarginsGuide)
            make.leading.equalTo(coverImageView.snp.trailing).offset(Constant.Spacing.normal)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-Constant.Spacing.normal)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        tapFavoriteCallBack = nil
    }
    
    func configureCell(with meetupEvent: MeetupEventList.DisplayHistoryEvent) {
        titleLabel.text = meetupEvent.title
        hostNameLabel.text = meetupEvent.hostName
        dateLabel.text = meetupEvent.dateText
        favoriteButton.tintColor = meetupEvent.favoriteButtonColor
        
        coverImageView.image = nil
        if let url = meetupEvent.coverImageURL {
            coverImageView.kf.setImage(with: url)
        }
    }
}

// MARK: - Action functions
extension HistoryMeetupEventCell {
    
    @objc func handleFavoriteButtonDidTap() {
        tapFavoriteCallBack?()
    }
}

// MARK: - Constants
extension HistoryMeetupEventCell {
    
    private enum Constant {
        enum Font {
            static let dateLabel: UIFont = .itContent
            static let titleLabel: UIFont = .itDescription
            static let hostNameLabel: UIFont = .itContent
        }
        
        enum Color {
            static let dateLabel: UIColor = .itGrayText
            static let titleLabel: UIColor = .itBlack
            static let hostNameLabel: UIColor = .itGrayText
            static let coverImageView: UIColor = .itGray
        }
        
        enum Image {
            static var favoriteButton: UIImage { #imageLiteral(resourceName: "bookmark").withRenderingMode(.alwaysTemplate) }
        }
        
        enum Spacing {
            static let normal: CGFloat = 16
        }
        
        enum Size {
            static let coverImage: CGSize = .init(width: 60, height: 60)
            static let favoriteIcon: CGSize = .init(width: 30, height: 30)
        }
        
        enum NumberOfLine {
            static let common: Int = 2
        }
    }
}
