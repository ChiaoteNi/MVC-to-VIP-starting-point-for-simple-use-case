//
//  MeetupEventFavoriteWorkerTests.swift
//  ITAppTests
//
//  Created by kuotinyen on 2020/10/28.
//

import XCTest
@testable import ITApp

class MeetupEventFavoriteWorkerTests: XCTestCase {
    private let sut: MeetupEventFavoriteWorker = .shared

    func test_toggleMeetupEventFavoriteState() {
        let persistenceWorker = UserDefaultsMock()
        sut.cp_resetPersistenceWorker(persistenceWorker: persistenceWorker)

        let meetupEventID = "3629778927084128"
        let fullID = sut.persistencePrefix + meetupEventID

        // empty
        persistenceWorker.verifyTestActionsOrder(to: [])
        XCTAssertEqual(sut.getFavoriteState(withID: meetupEventID), .unfavorite, "default meetup event should be unfavorite")
        persistenceWorker.verifyTestActionsOrder(to: [.fetchFavoriteState(meetupEventID: fullID)])

        // empty -> on
        sut.addFavoriteMeetupEvent(with: meetupEventID)
        persistenceWorker.verifyTestActionsOrder(to: [.fetchFavoriteState(meetupEventID: fullID),
                                                      .setFavoriteState(isFavorite: true, meetupEventID: fullID)])
        XCTAssertEqual(sut.getFavoriteState(withID: meetupEventID), .favorite, "set favorite on, should be favorite")
        persistenceWorker.verifyTestActionsOrder(to: [.fetchFavoriteState(meetupEventID: fullID),
                                                      .setFavoriteState(isFavorite: true, meetupEventID: fullID),
                                                      .fetchFavoriteState(meetupEventID: fullID)])

        // on -> off
        sut.removeFavoriteMeetupEvent(with: meetupEventID)
        persistenceWorker.verifyTestActionsOrder(to: [.fetchFavoriteState(meetupEventID: fullID),
                                                      .setFavoriteState(isFavorite: true, meetupEventID: fullID),
                                                      .fetchFavoriteState(meetupEventID: fullID),
                                                      .setFavoriteState(isFavorite: false, meetupEventID: fullID)])

        XCTAssertEqual(sut.getFavoriteState(withID: meetupEventID), .unfavorite, "set favorite off, should be unfavorite")
        persistenceWorker.verifyTestActionsOrder(to: [.fetchFavoriteState(meetupEventID: fullID),
                                                      .setFavoriteState(isFavorite: true, meetupEventID: fullID),
                                                      .fetchFavoriteState(meetupEventID: fullID),
                                                      .setFavoriteState(isFavorite: false, meetupEventID: fullID),
                                                      .fetchFavoriteState(meetupEventID: fullID)])
    }
}

// MARK: - UserDefaultsMock
private extension MeetupEventFavoriteWorkerTests {

    enum TestAction: Equatable {
        case fetchFavoriteState(meetupEventID: String)
        case setFavoriteState(isFavorite: Bool, meetupEventID: String)
    }

    class UserDefaultsMock: UserDefaults {
        private var eventIDs: [String] = []
        private var testActions: [TestAction] = []

        func verifyTestActionsOrder(to actions: [TestAction]) {
            XCTAssertEqual(testActions, actions)
        }

        override func set(_ value: Bool, forKey defaultName: String) {
            testActions.append(.setFavoriteState(isFavorite: value, meetupEventID: defaultName))
            guard !eventIDs.contains(where: { $0 == defaultName}) else { return }
            eventIDs.append(defaultName)
        }

        override func removeObject(forKey defaultName: String) {
            testActions.append(.setFavoriteState(isFavorite: false, meetupEventID: defaultName))
            guard let index = eventIDs.firstIndex(of: defaultName) else { return }
            eventIDs.remove(at: index)
        }

        override func object(forKey defaultName: String) -> Any? {
            testActions.append(.fetchFavoriteState(meetupEventID: defaultName))
            guard eventIDs.contains(where: { $0 == defaultName }) else { return false }
            return true
        }
    }
}
