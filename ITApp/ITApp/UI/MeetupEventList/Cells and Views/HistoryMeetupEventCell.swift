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
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(nil, for: .normal)
        button.tintColor = Constant.Color.favoriteButtonUnfavorite
        button.setImage(Constant.Image.favoriteButton, for: .normal)
        
        button.addTarget(self,
                         action: #selector(handleFavoriteButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    var tapFavoriteCallBack: ((MeetupEventFavoriteState) -> Void)?

    private var favoriteState: MeetupEventFavoriteState = .unfavorite {
        didSet {
            switch favoriteState {
            case .favorite:
                favoriteButton.tintColor = Constant.Color.favoriteButtonIsFavorite
            case .unfavorite:
                favoriteButton.tintColor = Constant.Color.favoriteButtonUnfavorite
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        selectionStyle = .none
        
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.layoutMarginsGuide)
            make.width.equalTo(Constant.coverImageLength)
            make.height.equalTo(Constant.coverImageLength)
        }
        
        contentView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.layoutMarginsGuide)
            make.size.equalTo(Constant.favoriteIconSize)
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
        favoriteState = .unfavorite
    }

    func configureCell(with meetupEvent: MeetupEvent, favoriteState: MeetupEventFavoriteState) {
        self.favoriteState = favoriteState

        titleLabel.text = meetupEvent.title
        hostNameLabel.text = meetupEvent.hostName

        if let eventDate = meetupEvent.date {
            dateLabel.text = getDateText(with: eventDate)
        } else {
            dateLabel.text = ""
        }

        coverImageView.image = nil
        if let coverImageUrl = meetupEvent.coverImageLink, let url = URL(string: coverImageUrl) {
            coverImageView.kf.setImage(with: url)
        }
    }

    private func getDateText(with date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constant.dateFormat
        return formatter.string(from: date)
    }
}

// MARK: - Action functions
extension HistoryMeetupEventCell {
    
    @objc func handleFavoriteButtonDidTap() {
        favoriteState = !favoriteState
        tapFavoriteCallBack?(favoriteState)
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
            static let favoriteButtonIsFavorite: UIColor = .itOrange
            static let favoriteButtonUnfavorite: UIColor = .itLightGray
        }
        
        enum Image {
            static var favoriteButton: UIImage { #imageLiteral(resourceName: "bookmark").withRenderingMode(.alwaysTemplate) }
        }
        
        enum Spacing {
            static let normal: CGFloat = 16
        }
        
        enum NumberOfLine {
            static let common: Int = 2
        }
        
        static let coverImageLength: CGFloat = 60
        static let favoriteIconSize: CGSize = .init(width: 30, height: 30)
        static var dateFormat: String { "MM月dd日" }
    }
}
