//
//  ITColor.swift
//  ITApp
//
//  Created by kuotinyen on 2020/10/5.
//

import UIKit

extension UIColor {
    static let itBlue: UIColor = .init(hex: 0x007AFE)
    static let itBlack: UIColor = .black
    static let itWhite: UIColor = .white
    static let itOrange: UIColor = .init(hex: 0xF6C244)
    
    static let itGray: UIColor = .init(hex: 0xD8D8D8)
    static let itLightGray: UIColor = .init(hex: 0xE2E2E2)
    static let itGrayText: UIColor = .init(hex: 0x8E8E93)
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
