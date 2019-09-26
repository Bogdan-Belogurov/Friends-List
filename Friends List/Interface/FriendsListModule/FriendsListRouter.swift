//
//  FriendsListRouter.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol FriendsListRouterProtocol: class {
    func showDetailViewController(friend: IFriend?, service: IFriendsService?)
}

class FriendsListRouter {
    weak var friendsListViewController: BaseViewController?
    init(view: FriendsListViewController) {
        self.friendsListViewController = view
    }
}

extension FriendsListRouter: FriendsListRouterProtocol {
    func showDetailViewController(friend: IFriend?, service: IFriendsService?) {
        let detailViewController = DetailBuilder.build(friend: friend, service: service)
        friendsListViewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
