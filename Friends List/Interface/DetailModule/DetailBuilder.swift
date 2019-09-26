//
//  FriendsListBuilder.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

class DetailBuilder {
    static func build(friend: IFriend?, service: IFriendsService?) -> UIViewController {
        let detailViewController = DetailViewController()
        let interactor = DetailInteractor(service: service)
        let router = DetailRouter(view: detailViewController)
        let presenter = DetailPresenter(view: detailViewController, interactor: interactor, router: router, friend: friend)
        detailViewController.presenter = presenter
        return detailViewController
    }
}
