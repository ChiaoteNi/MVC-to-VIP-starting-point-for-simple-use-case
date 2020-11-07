//
//  MeetupEventListHeaderView.swift
//  ITApp
//
//  Created by Chiaote Ni on 2020/10/14.
//

import UIKit

final class MeetupEventListHeaderView: UITableViewHeaderFooterView {
    
    static var reusableIdentifier: String {
        String(describing: self)
    }
    
    private let titleLabel: UILabel = .init()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not support setup by GUI")
    }

    func configureHeader(title: String, font: UIFont) {
        titleLabel.text = title
        titleLabel.font = font
    }
}

// MARK: - Private functions
extension MeetupEventListHeaderView {
    
    private func setupViews() {
        contentView.directionalLayoutMargins = Constant.margins
        contentView.backgroundColor = Constant.Color.background
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView.layoutMarginsGuide)
        }
    }
}

// MARK: - Constants
extension MeetupEventListHeaderView {
    
    private enum Constant {
        enum Color {
            static var background: UIColor { return .itWhite }
        }
        
        static let margins: NSDirectionalEdgeInsets = .init(
            top: 8,
            leading: 20,
            bottom: 8,
            trailing: 20
        )
    }
}
