//
//  DetailViewController.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit
import MessageUI

protocol DetailViewProtocol: class {
    func updateViewWithFriend(friend: IFriend?)
}

class DetailViewController: BaseViewController {
    fileprivate let detailCellId = "detailCellId"
    fileprivate let favoriteFruitCellId = "favoriteFruitCellId"
    fileprivate let eyeColorCellId = "eyeColorCellId"
    fileprivate let tagsCellId = "tagsCellId"
    fileprivate let friendsCellId = "friendsCellId"
    var presenter: DetailPresenterProtocol?
    let titleArray = ["Age", "Company", "Email", "Phone", "Adress", "About", "Registered", "Latitude/Longitude", "Balance"]
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var friend: IFriend?
    private var ownFriends: [Int]?
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        tableView.register(DetailCell.self, forCellReuseIdentifier: detailCellId)
        tableView.register(FavoriteFruitCell.self, forCellReuseIdentifier: favoriteFruitCellId)
        tableView.register(EyeColorCell.self, forCellReuseIdentifier: eyeColorCellId)
        tableView.register(TagsCell.self, forCellReuseIdentifier: tagsCellId)
        tableView.register(FriendsCell.self, forCellReuseIdentifier: friendsCellId)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setupConstraints()
    }

    private func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:  true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 2:
                guard let email = friend?.email else { return }
                presenter?.showMailView(email: email)
            case 3:
                guard let number = friend?.phone?.filter("0123456789.".contains) else { return }
                presenter?.makeCall(number: number)
            case 7:
                guard let latitude = friend?.latitude, let longitude = friend?.longitude else { return }
                presenter?.openCoordinateInMap(latitude: latitude, longitude: longitude)
            default:
                break
            }
        }
        if indexPath.section == 4 {
            guard let cell = tableView.cellForRow(at: indexPath) as? FriendsCell else { return }
            if cell.isActive {
                guard let friendId = ownFriends?[indexPath.row], let friend = presenter?.getFriend(id: friendId) else { return }
                presenter?.showDetail(with: friend)
            }
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 4 {
            return "Friends:"
        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return titleArray.count
        case 4:
            return ownFriends?.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let detailCell = tableView.dequeueReusableCell(withIdentifier: detailCellId, for: indexPath) as? DetailCell, let friend = friend else { return UITableViewCell() }
            let title = titleArray[indexPath.row]
            switch indexPath.row {
            case 0:
                let description = String(friend.age)
                detailCell.configurateCell(title: title, description: description)
                detailCell.selectionStyle = .none
            case 1:
                guard let description = friend.company else { break }
                detailCell.configurateCell(title: title, description: description)
                detailCell.selectionStyle = .none
            case 2:
                guard let description = friend.email else { break }
                detailCell.configurateCell(title: title, description: description)
            case 3:
                guard let description = friend.phone else { break }
                detailCell.configurateCell(title: title, description: description)
            case 4:
                guard let description = friend.address else { break }
                detailCell.configurateCell(title: title, description: description)
                detailCell.selectionStyle = .none
            case 5:
                guard let description = friend.about else { break }
                detailCell.configurateCell(title: title, description: description)
                detailCell.selectionStyle = .none
            case 6:
                guard let date = friend.registered else { break }
                let description = presenter?.formatedDate(date) ?? "No registration date"
                detailCell.configurateCell(title: title, description: description)
                detailCell.selectionStyle = .none
            case 7:
                let description = presenter?.formatedCoordinate(latitude: friend.latitude, longitude: friend.longitude) ?? "No coordinate"
                detailCell.configurateCell(title: title, description: description)
            case 8:
                guard let availableFundsString = friend.balance else { break }
                let description = presenter?.formatedBalance(availableFundsString) ?? "No funds"
                detailCell.configurateCell(title: title, description: description)
                detailCell.selectionStyle = .none
            default:
                break
            }
            return detailCell
        }
        
        if indexPath.section == 1 {
            guard let tagsCell = tableView.dequeueReusableCell(withIdentifier: favoriteFruitCellId, for: indexPath) as? FavoriteFruitCell, let favoriteFruit = friend?.favoriteFruit else { return UITableViewCell()}
            tagsCell.configurateCell(favoriteFruit: favoriteFruit)
            tagsCell.selectionStyle = .none
            return tagsCell
        }
        
        if indexPath.section == 2 {
            guard let eyeColorCell = tableView.dequeueReusableCell(withIdentifier: eyeColorCellId, for: indexPath) as? EyeColorCell, let eyeColor = friend?.eyeColor else { return UITableViewCell()}
            eyeColorCell.configurateCell(eyeColor: eyeColor)
            eyeColorCell.selectionStyle = .none
            return eyeColorCell
        }
        
        if indexPath.section == 3 {
            guard let tagsCell = tableView.dequeueReusableCell(withIdentifier: tagsCellId, for: indexPath) as? TagsCell, let tags = friend?.tags else { return UITableViewCell()}
            presenter?.tagsPresenter = tagsCell.presenter
            presenter?.setTags(tags: tags)
            tagsCell.selectionStyle = .none
            return tagsCell
        }
        
        if indexPath.section == 4 {
            guard let friendsCell = tableView.dequeueReusableCell(withIdentifier: friendsCellId, for: indexPath) as? FriendsCell, let friendId = ownFriends?[indexPath.row], let friend = presenter?.getFriend(id: friendId) else { return UITableViewCell()}
            friendsCell.setupCell(name: friend.name, email: friend.email, isActive: friend.isActive)
            return friendsCell
        }
        return UITableViewCell()
    }
}

extension DetailViewController: DetailViewProtocol {
    func updateViewWithFriend(friend: IFriend?) {
        self.friend = friend
        guard let name = friend?.name else { return }
        ownFriends = friend?.friends
        self.navigationItem.title = "\(name)"
    }
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
