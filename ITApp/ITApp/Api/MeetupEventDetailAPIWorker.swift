//
//  MeetupEventDetailAPIWorker.swift
//  ITApp
//
//  Created by Chiaote Ni on 2020/11/5.
//  Copyright © 2020 iOS@Taipei in iPlayground. All rights reserved.
//

import Foundation

class MeetupEventDetailAPIWorker {

    typealias APIResult = Result<MeetupEvent, Error>
    typealias APICallback = (APIResult) -> Void
    
    struct DemoAPIError: Error {
        var localizedDescription: String {
            "Demo api request success, but target Event not found."
        }
    }

    private let jsonAPIWorker: JsonAPIWorker

    init(jsonAPIWorker: JsonAPIWorker = .init()) {
        self.jsonAPIWorker = jsonAPIWorker
    }

    func fetchMeetupEvent(eventID: String, callback: @escaping APICallback) {
        guard let url = URL(string: Constant.Fake.jsonFileName) else { return }

        jsonAPIWorker.fetchModel(from: url) { (result: Result<MeetupEventListResultRawModel, Error>) in
            switch result {
            case let .success(resultRawModel):
                guard let targetEvent = resultRawModel.data.first(where: { $0.id == eventID }) else {
                    return callback(.failure(DemoAPIError()))
                }
                
                let meetupEvent = targetEvent.makeMeetupEvent()
                callback(.success(meetupEvent))
            case let .failure(error):
                callback(.failure(error))
            }
        }
    }
}

// MARK: - Constant
extension MeetupEventDetailAPIWorker {

    private enum Constant {
        enum Fake {
            static var jsonFileName: String { "fake-meetup-event-list" }
        }
    }
}
