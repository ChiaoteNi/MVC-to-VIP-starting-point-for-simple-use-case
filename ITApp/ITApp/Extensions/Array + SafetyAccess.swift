//
//  Array + Safety Access.swift
//  ITApp
//
//  Created by Chiaote Ni on 2020/10/16.
//

import Foundation

extension Array {
    
    subscript(safe index: Int) -> Element? {
        get {
            guard index >= 0, index < count else { return nil }
            return self[index]
        }
        set {
            guard index >= 0, index < count, let newValue = newValue else { return }
            self[index] = newValue
        }
    }
}
