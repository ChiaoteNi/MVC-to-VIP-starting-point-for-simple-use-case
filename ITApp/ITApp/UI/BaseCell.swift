//
//  BaseCell.swift
//  ITApp
//
//  Created by kuotinyen on 2020/10/5.
//

import UIKit

class BaseCell: UITableViewCell {
    static var reusableIdentifier: String {
        String(describing: self)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    func setupViews() {
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
