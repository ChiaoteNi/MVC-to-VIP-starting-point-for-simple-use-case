//
//  MeetupEventListAPIWorker.swift
//  ITApp
//
//  Created by kuotinyen on 2020/10/26.
//

import Foundation

class MeetupEventListAPIWorker {

    typealias APIResult = Result<[MeetupEvent], Error>
    typealias APICallback = (APIResult) -> Void

    private let jsonAPIWorker: JsonAPIWorker

    init(jsonAPIWorker: JsonAPIWorker = .init()) {
        self.jsonAPIWorker = jsonAPIWorker
    }

    func fetchMeetupEvents(callback: @escaping APICallback) {
        guard let url = URL(string: Constant.Fake.jsonFileName) else { return }

        jsonAPIWorker.fetchModel(from: url) { (result: Result<MeetupEventListResultRawModel, Error>) in
            switch result {
            case let .success(resultRawModel):
                let meetupEvents = resultRawModel.data.map { $0.makeMeetupEvent() }
                callback(.success(meetupEvents))
            case let .failure(error):
                callback(.failure(error))
            }
        }
    }
}

// MARK: - Constant
extension MeetupEventListAPIWorker {

    private enum Constant {
        enum Fake {
            static var jsonFileName: String { "fake-meetup-event-list" }
        }
    }
}
