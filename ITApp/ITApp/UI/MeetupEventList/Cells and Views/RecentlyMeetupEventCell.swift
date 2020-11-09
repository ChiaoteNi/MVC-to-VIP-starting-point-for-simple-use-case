//
//  RecentlyMeetupEventCell.swift
//  ITApp
//
//  Created by Chiaote Ni on 2020/10/13.
//

import UIKit
import SnapKit

final class RecentlyMeetupEventCell: BaseCell {

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
        imageView.layer.cornerRadius = Constant.imageCornerRadius
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = Constant.Color.coverImageView
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width).multipliedBy(Constant.coverImageLengthRatio)
        }
        return imageView
    }()
    
    private let seperator: UIView = {
        let seperator: UIView = .init()
        seperator.backgroundColor = Constant.Color.seperator
        
        seperator.snp.makeConstraints { make in
            make.height.equalTo(Constant.seperatorHeight)
        }
        return seperator
    }()
    
    override func setupViews() {
        super.setupViews()
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            dateLabel,
            titleLabel,
            hostNameLabel,
            coverImageView,
            seperator
        ])
        
        stackView.axis = .vertical
        stackView.spacing = Constant.Spacing.common
        
        stackView.setCustomSpacing(
            Constant.Spacing.titleAndCover,
            after: titleLabel
        )

        stackView.setCustomSpacing(
            Constant.Spacing.coverAndSeperator,
            after: coverImageView
        )
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.layoutMarginsGuide)
        }
        
        coverImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView.layoutMarginsGuide)
        }
    }
    
    // MARK: Configurate Cell.
    
    func configureCell(with meetupEvent: MeetupEventList.DisplayRecentlyEvent) {
        // TODO: 這邊用轉換好的UIModel來建立Cell畫面顯示
    }
}

// MARK: - Constants
extension RecentlyMeetupEventCell {
    
    private enum Constant {
        enum Font {
            static let dateLabel: UIFont = .itFootnote
            static let titleLabel: UIFont = .itHeader
            static let hostNameLabel: UIFont = .itFootnote
        }
        
        enum Color {
            static let dateLabel: UIColor = .itBlue
            static let titleLabel: UIColor = .itBlack
            static let hostNameLabel: UIColor = .itGrayText
            static let seperator: UIColor = .itLightGray
            static let coverImageView: UIColor = .itGray
        }
        
        enum Spacing {
            static let common: CGFloat = 8
            static let titleAndCover: CGFloat = 16
            static let coverAndSeperator: CGFloat = 24
        }
        
        enum NumberOfLine {
            static let common: Int = 2
        }
        
        static let imageCornerRadius: CGFloat = 5
        static let seperatorHeight: CGFloat = 1
        static let coverImageLengthRatio: CGFloat = 220/335
    }
}
