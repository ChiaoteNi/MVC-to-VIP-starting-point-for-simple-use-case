//
//  MeetupEventDetailViewController.swift
//  ITApp
//
//  Created by kuotinyen on 2020/10/4.
//

import UIKit
import SnapKit
import Kingfisher

final class MeetupEventDetailViewController: UIViewController {

    enum RowType: Int, CaseIterable {
        case coverImage
        case mainInfo
        case description
    }

    private lazy var tableView: UITableView = .init()
    
    private let eventDetailWorker: MeetupEventDetailAPIWorker = .init()
    private let favoriteManager: MeetupEventFavoriteWorker = .shared
    
    private var meetupEventID: String
    private var meetupEvent: MeetupEvent?
    private var favoriteState: MeetupEventFavoriteState = .unfavorite

    init(meetupEventID: String) {
        self.meetupEventID = meetupEventID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View lifecycle

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
extension MeetupEventDetailViewController {

    private func setupViews() {
        setupTableView()
        setupNavigationBar()
    }

    private func setupTableView() {
        tableView.register(MeetupEventCoverImageCell.self, forCellReuseIdentifier: MeetupEventCoverImageCell.reusableIdentifier)
        tableView.register(MeetupEventMainInfoCell.self, forCellReuseIdentifier: MeetupEventMainInfoCell.reusableIdentifier)
        tableView.register(MeetupEventDescriptionCell.self, forCellReuseIdentifier: MeetupEventDescriptionCell.reusableIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        navigationItem.title = Constant.Title
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(handleTapClose))
    }
    
    private func loadData() {
        eventDetailWorker.fetchMeetupEvent(eventID: meetupEventID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let meetupEvent):
                self.meetupEvent = meetupEvent
                self.favoriteState = self.favoriteManager.getFavoriteState(withID: self.meetupEventID)
            case .failure(let error):
                print(error)
            }
        }
    }

    @objc func handleTapClose() {
        dismiss(animated: true, completion: nil)
    }

    private func getDateText(with date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constant.dateFormat
        return formatter.string(from: date)
    }

    private func observeEventFavoriteStateChange() {
        favoriteManager.addObserver(self)
    }
}

// MARK: - UITableView DataSource
extension MeetupEventDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetupEvent != nil ? RowType.allCases.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let content = RowType.allCases[safe: indexPath.row],
            let meetupEvent = meetupEvent else { return UITableViewCell() }

        switch content {
        case .coverImage:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MeetupEventCoverImageCell.reusableIdentifier, for: indexPath) as? MeetupEventCoverImageCell {
                cell.configureCell(with: meetupEvent)
                return cell
            }
        case .mainInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MeetupEventMainInfoCell.reusableIdentifier, for: indexPath) as? MeetupEventMainInfoCell {
                cell.configureCell(with: meetupEvent, favoriteState: favoriteState)
                cell.tapFavoriteCallBack = { [weak self] cellFavoriteState in
                    guard let self = self else { return }

                    switch cellFavoriteState {
                    case .favorite:
                        self.favoriteManager.addFavoriteMeetupEvent(with: self.meetupEventID)
                    case .unfavorite:
                        self.favoriteManager.removeFavoriteMeetupEvent(with: self.meetupEventID)
                    }
                }
                return cell
            }
        case .description:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MeetupEventDescriptionCell.reusableIdentifier, for: indexPath) as? MeetupEventDescriptionCell {
                cell.configureCell(with: meetupEvent)
                return cell
            }
        }

        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension MeetupEventDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let content = RowType(rawValue: indexPath.row) else { return .zero }

        switch content {
        case .coverImage:
            return Constant.imageCellHeight
        case .mainInfo, .description:
            return UITableView.automaticDimension
        }
    }
}

// MARK: - MeetupEventFavorite Observer
extension MeetupEventDetailViewController: MeetupEventFavoriteObserver {

    func favoriteStateDidChanged(eventID: String, to newState: MeetupEventFavoriteState) {
        favoriteState = newState
    }

    func favoriteStateChanged(event eventID: String, chagneTo state: MeetupEventFavoriteState) {
        favoriteState = favoriteManager.getFavoriteState(withID: self.meetupEventID)
        tableView.reloadRows(at: [.init(row: RowType.mainInfo.rawValue, section: .zero)], with: .fade)
    }
}

// MARK: - Constants
extension MeetupEventDetailViewController {
    
    private enum Constant {
        static let imageCellHeight: CGFloat = 240
        static var dateFormat: String { "yyyy年MM月dd日 HH:mm" }
        static var Title: String { "活動詳情" }
    }
}
