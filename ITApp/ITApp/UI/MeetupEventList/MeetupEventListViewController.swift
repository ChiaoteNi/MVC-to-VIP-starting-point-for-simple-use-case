//
//  MeetupEventListViewController.swift
//  ITApp
//
//  Created by kuotinyen on 2020/10/4.
//

import UIKit
import Kingfisher

final class MeetupEventListViewController: UIViewController {

    enum SectionType: Int, CaseIterable {
        case recently
        case history
    }

    private lazy var tableView: UITableView = .init()
    private let meetupEventListAPIWorker: MeetupEventListAPIWorker = .init()
    private let favoriteManager: MeetupEventFavoriteWorker = .shared
    private var recentlyEvents: [MeetupEvent] = []
    private var historyEvents: [MeetupEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        observeEventFavoriteStateChange()
        loadData()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        guard parent == nil else { return }
        favoriteManager.removeObserver(self)
    }
}

// MARK: - Private functions
extension MeetupEventListViewController {
    
    private func setupViews() {
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(RecentlyMeetupEventCell.self, forCellReuseIdentifier: RecentlyMeetupEventCell.reusableIdentifier)
        tableView.register(HistoryMeetupEventCell.self, forCellReuseIdentifier: HistoryMeetupEventCell.reusableIdentifier)
        tableView.register(MeetupEventListHeaderView.self, forHeaderFooterViewReuseIdentifier: MeetupEventListHeaderView.reusableIdentifier)

        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func loadData() {
        meetupEventListAPIWorker.fetchMeetupEvents { [weak self] (result) in
            self?.handle(fetchMeetupEvents: result)
        }
    }

    private func handle(fetchMeetupEvents result: MeetupEventListAPIWorker.APIResult) {
        switch result {
        case let .success((recentlyEvents, historyEvents)):
            self.recentlyEvents = recentlyEvents
            self.historyEvents = historyEvents
            self.tableView.reloadData()
        case let .failure(error):
            print("#### error -> \(error)")
        }
    }
    
    private func observeEventFavoriteStateChange() {
        favoriteManager.addObserver(self)
    }
}

// MARK: - UITableView DataSource
extension MeetupEventListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let eventType = SectionType.allCases[safe: section] else { return 0 }
        
        switch eventType {
        case .recently: return recentlyEvents.count
        case .history:  return historyEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let eventType = SectionType.allCases[safe: indexPath.section] else { return UITableViewCell() }
        
        switch eventType {
        case .recently:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecentlyMeetupEventCell.reusableIdentifier, for: indexPath) as? RecentlyMeetupEventCell {
                guard let meetupEvent = recentlyEvents[safe: indexPath.row] else { return cell }
                cell.configureCell(with: meetupEvent)
                return cell
            }
        case .history:
            if let cell = tableView.dequeueReusableCell(withIdentifier: HistoryMeetupEventCell.reusableIdentifier, for: indexPath) as? HistoryMeetupEventCell {
                guard let meetupEvent = historyEvents[safe: indexPath.row] else { return cell }
                
                let favoriteState: MeetupEventFavoriteState = favoriteManager.getFavoriteState(withID: meetupEvent.id)
                cell.configureCell(with: meetupEvent, favoriteState: favoriteState)

                cell.tapFavoriteCallBack = { [weak self] cellFavoriteState in
                    switch cellFavoriteState {
                    case .favorite:
                        self?.favoriteManager.addFavoriteMeetupEvent(with: meetupEvent.id)
                    case .unfavorite:
                        self?.favoriteManager.removeFavoriteMeetupEvent(with: meetupEvent.id)
                    }
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let eventType = SectionType.allCases[safe: section],
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MeetupEventListHeaderView.reusableIdentifier) as? MeetupEventListHeaderView else { return nil }
        
        switch eventType {
        case .recently:
            headerView.configureHeader(
                title: Constant.Text.recentlyEventHeader,
                font: Constant.Font.recentlyEventHeader
            )
        case .history:
            headerView.configureHeader(
                title: Constant.Text.historyEventHeader,
                font: Constant.Font.historyEventHeader
            )
        }
        
        return headerView
    }
}

// MARK: - UITableView Delegate
extension MeetupEventListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeetupEventID: String?

        switch indexPath.section {
        case SectionType.recently.rawValue:
            selectedMeetupEventID = recentlyEvents[safe: indexPath.row]?.id
        case SectionType.history.rawValue:
            selectedMeetupEventID = historyEvents[safe: indexPath.row]?.id
        default:
            selectedMeetupEventID = nil
        }

        guard let meetupEventID = selectedMeetupEventID else { return }
        let meetupEventDetailViewController = MeetupEventDetailViewController(meetupEventID: meetupEventID)
        let navigationController = UINavigationController(rootViewController: meetupEventDetailViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - MeetupEventFavorite Observer function.
extension MeetupEventListViewController: MeetupEventFavoriteObserver {

    func favoriteStateDidChanged(eventID: String, to newState: MeetupEventFavoriteState) {
        guard
            let row = historyEvents.firstIndex(where: { $0.id == eventID }),
            let section = SectionType.allCases.firstIndex(where: { $0 == .history }) else { return }

        tableView.reloadRows(at: [.init(row: row, section: section)], with: .fade)
    }
}

// MARK: - Constants
extension MeetupEventListViewController {
    
    private enum Constant {
        enum Font {
            static let recentlyEventHeader: UIFont = .itLargeTitle
            static let historyEventHeader: UIFont = .itTitle
        }
        
        enum Text {
            static var recentlyEventHeader: String { "近期活動" }
            static var historyEventHeader: String { "活動紀錄" }
        }

        enum Fake {
            static var jsonFileName: String { "fake-meetup-event-list" }
            static var jsonFileExtension: String { "json" }
        }
        
        static var dateFormat: String { "MM月dd日" }
    }
}
