//
//  FriendsListViewController
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

protocol FriendsListViewProtocol: class {
    func updateFriends(friends: [IFriend]?)
    func showAlert(for error: ApiError)
    func endRefreshing()
}

class FriendsListViewController: BaseViewController {
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return view
    }()
    
    private var friends: [IFriend]?
    var presenter: FriendsListPresenterProtocol?
    fileprivate let cellId = "friendsListCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Friends List"
        view.addSubview(tableView)
        setupConstraints()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendsCell.self, forCellReuseIdentifier: cellId)
        setupRefreshControl()
        self.friends = presenter?.friends()
        if self.friends!.isEmpty {
            presenter?.getFriends()
        } else {
            self.tableView.reloadData()
        }
    }
    
    private func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    }

    @objc private func refresh(sender: UIRefreshControl) {
        presenter?.getFriends()
    }
}

extension FriendsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? FriendsCell else { return }
        if cell.isActive {
            guard let friend = self.friends?[indexPath.row] else { return }
            presenter?.showDetail(with: friend)
        }
    }
}

extension FriendsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FriendsCell, let friend = self.friends?[indexPath.row] else {return UITableViewCell()}
        cell.setupCell(name: friend.name, email: friend.email, isActive: friend.isActive)
        return cell
    }
}

extension FriendsListViewController: FriendsListViewProtocol {
    func endRefreshing() {
        self.refreshControl.endRefreshing()
    }
    
    func updateFriends(friends: [IFriend]?) {
        self.friends = friends
        self.tableView.reloadData()
    }
    
    func showAlert(for error: ApiError) {
        if let _ = error.error {
            let message = error.message
            self.showAlert(title: message)
        }
    }
}
