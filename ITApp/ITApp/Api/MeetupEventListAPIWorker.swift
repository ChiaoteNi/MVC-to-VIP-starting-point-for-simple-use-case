//
//  MeetupEventListAPIWorker.swift
//  ITApp
//
//  Created by kuotinyen on 2020/10/26.
//

import Foundation

class MeetupEventListAPIWorker {

    typealias APIResult = Result<([MeetupEvent], [MeetupEvent]), Error>
    typealias APICallback = (APIResult) -> Void

    private let jsonAPIWorker: JsonAPIWorker

    init(jsonAPIWorker: JsonAPIWorker = .init()) {
        self.jsonAPIWorker = jsonAPIWorker
    }

    func fetchMeetupEvents(callback: @escaping APICallback) {
        
        guard let path = Bundle.main.path(forResource: Constant.Fake.jsonFileName,
                                          ofType: Constant.Fake.jsonFileExtension) else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return }
        
        let recentlyEvents: [MeetupEvent]
        let historyEvents: [MeetupEvent]
        
        do {
            let resultRawModel = try JSONDecoder().decode(MeetupEventListResultRawModel.self,
                                                          from: data)
            let meetupEvents = resultRawModel.data.map { $0.makeMeetupEvent() }

            // FIXME: Make it more reasonable to check recently logic
            if let firstEvent = meetupEvents.first {
                recentlyEvents = [firstEvent]
            } else {
                recentlyEvents = []
            }
            historyEvents = Array(meetupEvents.dropFirst())
            
            callback(.success((recentlyEvents, historyEvents)))
        } catch {
            print("#### catch errror: \(error)")
            callback(.failure(error))
        }
        
//        guard let url = URL(string: Constant.Fake.jsonFileName) else { return }
//
//        jsonAPIWorker.fetchModel(from: url) { (result: Result<MeetupEventListResultRawModel, Error>) in
//            switch result {
//            case let .success(resultRawModel):
//                let meetupEvents = resultRawModel.data.map { $0.makeMeetupEvent() }
//                let recentlyEvents: [MeetupEvent]
//                let historyEvents: [MeetupEvent]
//
//                // FIXME: Make it more reasonable to check recently logic
//                if let firstEvent = meetupEvents.first {
//                    recentlyEvents = [firstEvent]
//                } else {
//                    recentlyEvents = []
//                }
//
//                historyEvents = Array(meetupEvents.dropFirst())
//                callback(.success((recentlyEvents, historyEvents)))
//            case let .failure(error):
//                callback(.failure(error))
//            }
//        }
    }
}

// MARK: - Constant
extension MeetupEventListAPIWorker {

    private enum Constant {
        enum Fake {
            static var jsonFileName: String { "fake-meetup-event-list" }
            static var jsonFileExtension: String { "json" }
        }
    }
}
