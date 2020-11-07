//
//  MeetupEventMainInfoCell.swift
//  ITApp
//
//  Created by kuotinyen on 2020/10/5.
//

import UIKit

final class MeetupEventMainInfoCell: BaseCell {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.dateLabel
        label.textColor = Constant.Color.dateLabel
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.titleLabel
        label.textColor = Constant.Color.commonLabel
        label.numberOfLines = Constant.NumberOfLine.common
        return label
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(nil, for: .normal)
        button.tintColor = Constant.Color.favoriteButtonOff
        button.setImage(Constant.Image.favoriteButton, for: .normal)
        button.snp.makeConstraints { (make) in
            make.size.equalTo(Constant.Size.favoriteButton)
        }

        button.addTarget(self,
                         action: #selector(handleTapFavoriteButton),
                         for: .touchUpInside)
        return button
    }()

    private let hostNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.hostNameLabel
        label.textColor = Constant.Color.commonLabel
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.addressLabel
        label.textColor = Constant.Color.commonLabel
        label.numberOfLines = Constant.NumberOfLine.common
        return label
    }()

    var tapFavoriteCallBack: ((MeetupEventFavoriteState) -> Void)?
    
    private var favoriteState: MeetupEventFavoriteState = .unfavorite {
        didSet {
            switch favoriteState {
            case .favorite:
                favoriteButton.tintColor = Constant.Color.favoriteButtonOn
            case .unfavorite:
                favoriteButton.tintColor = Constant.Color.favoriteButtonOff
            }
        }
    }

    override func setupViews() {
        super.setupViews()

        contentView.directionalLayoutMargins = Constant.margins

        let stackView = UIStackView(arrangedSubviews: [dateLabel,
                                                       makeTitleFavoriteStackView(),
                                                       hostNameLabel,
                                                       addressLabel])
        stackView.axis = .vertical
        stackView.spacing = Constant.Spacing.common
        stackView.setCustomSpacing(Constant.Spacing.dateAndTitle, after: dateLabel)

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.layoutMarginsGuide)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        tapFavoriteCallBack = nil
        favoriteState = .unfavorite
    }

    func configureCell(with meetupEvent: MeetupEvent, favoriteState: MeetupEventFavoriteState) {
        self.favoriteState = favoriteState

        if let eventDate = meetupEvent.date {
            dateLabel.text = getDateText(with: eventDate)
        } else {
            dateLabel.text = ""
        }

        titleLabel.text = meetupEvent.title
        hostNameLabel.text = meetupEvent.hostName
        addressLabel.text = meetupEvent.address
    }

    @objc func handleTapFavoriteButton() {
        favoriteState = !favoriteState
        tapFavoriteCallBack?(favoriteState)
    }
}

// MARK: - Private Methods
extension MeetupEventMainInfoCell {

    private func makeTitleFavoriteStackView() -> UIView {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       favoriteButton])
        stackView.axis = .horizontal
        stackView.spacing = Constant.Spacing.TitleAndFavoriteButton
        stackView.alignment = .top
        return stackView
    }

    private func getDateText(with date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constant.dateFormat
        return formatter.string(from: date)
    }
}

// MARK: - Constants
extension MeetupEventMainInfoCell {
    
    private enum Constant {
        static let margins: NSDirectionalEdgeInsets = .init(top: 16,
                                                            leading: 20,
                                                            bottom: 24,
                                                            trailing: 20)

        static var dateFormat: String { "MM月dd日" }

        enum NumberOfLine {
            static let common: Int = 2
        }

        enum Font {
            static let dateLabel: UIFont = .itFootnote
            static let titleLabel: UIFont = .itHeader
            static let hostNameLabel: UIFont = .itFootnote
            static let addressLabel: UIFont = .itFootnote
        }

        enum Color {
            static let commonLabel: UIColor = .itBlack
            static let dateLabel: UIColor = .itBlue
            static let favoriteButtonOn: UIColor = .itOrange
            static let favoriteButtonOff: UIColor = .itLightGray
        }

        enum Size {
            static let favoriteButton: CGSize = .init(width: 30, height: 30)
        }

        enum Image {
            static var favoriteButton: UIImage { #imageLiteral(resourceName: "bookmark").withRenderingMode(.alwaysTemplate) }
        }

        enum Spacing {
            static let common: CGFloat = 18
            static let dateAndTitle: CGFloat = 8
            static let TitleAndFavoriteButton: CGFloat = 20
        }
    }
}
