//
//  MeetupEventFavoriteState.swift
//  ITApp
//
//  Created by Chiaote Ni on 2020/11/5.
//  Copyright © 2020 iOS@Taipei in iPlayground. All rights reserved.
//

import Foundation

enum MeetupEventFavoriteState {
    case unfavorite
    case favorite
    
    static prefix func ! (value: MeetupEventFavoriteState) -> MeetupEventFavoriteState {
        if value == .favorite {
            return .unfavorite
        } else {
            return .favorite
        }
    }
}
