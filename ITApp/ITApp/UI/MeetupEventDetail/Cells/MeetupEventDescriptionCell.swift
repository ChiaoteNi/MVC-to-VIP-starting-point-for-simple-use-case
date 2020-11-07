//
//  MeetupEventDescriptionCell.swift
//  ITApp
//
//  Created by kuotinyen on 2020/10/5.
//

import UIKit

final class MeetupEventDescriptionCell: BaseCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.titleLabel
        label.textColor = Constant.Color.commonLabel
        label.text = Constant.titleText
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.descriptionLabel
        label.textColor = Constant.Color.commonLabel
        label.numberOfLines = .zero
        return label
    }()

    override func setupViews() {
        super.setupViews()

        contentView.directionalLayoutMargins = Constant.margins

        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = Constant.spacingBetweenTitleAndDescription

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.layoutMarginsGuide)
        }
    }

    func configureCell(with meetupEvent: MeetupEvent) {
        descriptionLabel.text = meetupEvent.description
    }
}

// MARK: - Constants
extension MeetupEventDescriptionCell {
    
    private enum Constant {
        static let margins: NSDirectionalEdgeInsets = .init(top: 24,
                                                            leading: 20,
                                                            bottom: 24,
                                                            trailing: 20)
        static let spacingBetweenTitleAndDescription: CGFloat = 11
        static var titleText: String { "詳情" }

        enum Color {
            static let commonLabel: UIColor = .itBlack
        }

        enum Font {
            static let titleLabel: UIFont = .itHeader
            static let descriptionLabel: UIFont = .itDescription
        }
    }
}
