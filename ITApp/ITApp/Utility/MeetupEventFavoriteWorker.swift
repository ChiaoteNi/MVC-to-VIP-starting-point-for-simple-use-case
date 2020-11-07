//
//  MeetupEventFavoriteManager.swift
//  ITApp
//
//  Created by Chiaote Ni on 2020/10/20.
//

import Foundation

protocol MeetupEventFavoriteObserver: AnyObject {
    func favoriteStateDidChanged(eventID: String, to newState: MeetupEventFavoriteState)
}

final class MeetupEventFavoriteWorker {
    var persistencePrefix: String = Constant.persistencePrefix
    private var observers: [MeetupEventFavoriteObserver] = []

    static let shared: MeetupEventFavoriteWorker = .init()
    private var persistenceWorker: UserDefaults = .standard
    private init() {}

    // MARK: - Favorite Action Relatives methods

    func addFavoriteMeetupEvent(with eventID: String) {
        persistenceWorker.set(true, forKey: persistencePrefix + eventID)
        observers.forEach { observer in
            observer.favoriteStateDidChanged(eventID: eventID, to: .favorite)
        }
    }
    
    func removeFavoriteMeetupEvent(with eventID: String) {
        persistenceWorker.removeObject(forKey: persistencePrefix + eventID)
        observers.forEach { observer in
            observer.favoriteStateDidChanged(eventID: eventID, to: .unfavorite)
        }
    }
    
    func getFavoriteState(withID eventID: String) -> MeetupEventFavoriteState {
        guard let isFavorite = persistenceWorker.object(forKey: persistencePrefix + eventID) as? Bool else { return .unfavorite }
        return isFavorite ? .favorite : .unfavorite
    }

    // MARK: - Observer Relatives methods

    func addObserver(_ observer: MeetupEventFavoriteObserver) {
        observers.append(observer)
    }

    func removeObserver(_ observer: MeetupEventFavoriteObserver) {
        observers.removeAll(where: { $0 === observer })
    }
}

// MARK: - Test Only methods
extension MeetupEventFavoriteWorker {
    // This function is a control point to reset persistenceWorker in test environment.
    func cp_resetPersistenceWorker(persistenceWorker: UserDefaults) {
        self.persistenceWorker = persistenceWorker
    }
}

// MARK: - Constant
extension MeetupEventFavoriteWorker {
    
    private enum Constant {
        static let persistencePrefix = "MeetupEvent"
    }
}
