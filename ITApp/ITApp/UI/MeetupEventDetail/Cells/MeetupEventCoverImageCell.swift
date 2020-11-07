//
//  MeetupEventCoverImageCell.swift
//  ITApp
//
//  Created by kuotinyen on 2020/10/5.
//

import UIKit
import Kingfisher

final class MeetupEventCoverImageCell: BaseCell {
    
    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()

    override func setupViews() {
        super.setupViews()

        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func configureCell(with meetupEvent: MeetupEvent) {
        if let imageUrlString = meetupEvent.coverImageLink, let url = URL(string: imageUrlString) {
            coverImageView.kf.setImage(with: url)
        }
    }
}
