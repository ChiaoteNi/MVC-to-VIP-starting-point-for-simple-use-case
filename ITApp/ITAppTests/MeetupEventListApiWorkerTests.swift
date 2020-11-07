//
//  MeetupEventListAPIWorkerTests.swift
//  ITAppTests
//
//  Created by kuotinyen on 2020/10/27.
//

import XCTest
@testable import ITApp

class MeetupEventListAPIWorkerTests: XCTestCase {

    private var sut: MeetupEventListAPIWorker!

    func test_fetchMeetupEventsSuccess() {
        sut = MeetupEventListAPIWorker(jsonAPIWorker: JsonAPIWorkerSuccessStub())
        sut.fetchMeetupEvents { (result: MeetupEventListAPIWorker.APIResult) in
            switch result {
            case let .success((recentlyEvents, historyEvents)):
                XCTAssertEqual(recentlyEvents.count, 1)
                XCTAssertEqual(historyEvents.count, 24)
            case .failure:
                XCTFail("Should not goes here.")
            }
        }
    }

    func test_fetchMeetupEventsFail() {
        let jsonAPIWorker = JsonAPIWorkerFailureStub()
        jsonAPIWorker.error = NSError(domain: "1", code: 2, userInfo: nil)

        sut = MeetupEventListAPIWorker(jsonAPIWorker: jsonAPIWorker)
        sut.fetchMeetupEvents { (result: MeetupEventListAPIWorker.APIResult) in
            switch result {
            case let .failure(error):
                XCTAssertEqual(error as NSError, NSError(domain: "1", code: 2, userInfo: nil))
            case .success:
                XCTFail("Should not goes here.")
            }
        }
    }
}

// MARK: - JsonAPIWorkerMock

private extension MeetupEventListAPIWorkerTests {
    class JsonAPIWorkerSuccessStub: JsonAPIWorker {
        private let jsonFileWorker: JsonFileWorker = .init()

        override func fetchModel<Model>(from url: URL, callback: @escaping (Result<Model, Error>) -> Void) where Model : Decodable, Model : Encodable {
            jsonFileWorker.fetchModel(from: url.absoluteString, callback: callback)
        }
    }

    class JsonAPIWorkerFailureStub: JsonAPIWorker {
        private let jsonFileWorker: JsonFileWorker = .init()
        var error: Error!

        override func fetchModel<Model>(from url: URL, callback: @escaping (Result<Model, Error>) -> Void) where Model : Decodable, Model : Encodable {
            callback(.failure(error))
        }
    }
}
