//
//  RawModels.swift
//  ITApp
//
//  Created by kuotinyen on 2020/10/18.
//

import Foundation

// MARK: MeetupEventRawModel

struct MeetupEventRawModel: Codable {
    let name: String
    let id: String
    let startTime: String
    let cover: MeetupEventCoverRawModel?
    let description: String?
    let place: MeetupEventPlaceRawModel?

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case startTime = "start_time"
        case cover
        case description
        case place
    }

    func makeMeetupEvent() -> MeetupEvent {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: startTime)
        
        // FIXME: Fetch real host name if have time
        return MeetupEvent(id: id,
                           title: name,
                           description: description,
                           coverImageLink: cover?.source,
                           hostName: "好心人",
                           address: place?.name,
                           date: date)
    }
}

// MARK: MeetupEventCoverRawModel

struct MeetupEventCoverRawModel: Codable {
    let offsetY: Int
    let id: String
    let offsetX: Int
    let source: String

    enum CodingKeys: String, CodingKey {
        case offsetY = "offset_y"
        case id
        case offsetX = "offset_x"
        case source
    }
}

// MARK: MeetupEventListCursorsRawModel

struct MeetupEventListCursorsRawModel: Codable {
    let after, before: String
}

// MARK: MeetupEventListPagingRawModel

struct MeetupEventListPagingRawModel: Codable {
    let cursors: MeetupEventListCursorsRawModel
    let next: String
}

// MARK: MeetupEventListResultRawModel

struct MeetupEventListResultRawModel: Codable {
    let data: [MeetupEventRawModel]
    let paging: MeetupEventListPagingRawModel
}

// MARK: MeetupEventPlaceRawModel

struct MeetupEventPlaceRawModel: Codable {
    let name: String
}
