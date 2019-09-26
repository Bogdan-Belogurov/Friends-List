//
//  FriendsListBuilder.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

class FriendsListBuilder {
    static func build(service: IFriendsService) -> UIViewController {
        let friendsListViewController = FriendsListViewController()
        let interactor = FriendsListInteractor(service: service)
        let router = FriendsListRouter(view: friendsListViewController)
        let presenter = FriendsListPresenter(view: friendsListViewController, interactor: interactor, router: router)
        friendsListViewController.presenter = presenter
        let navigationController = BaseNavigationViewController(rootViewController: friendsListViewController)
        return navigationController
    }
}
