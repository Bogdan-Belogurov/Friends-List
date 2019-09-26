//
//  FriendsListPresenter.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol FriendsListPresenterProtocol: class {
    var router: FriendsListRouterProtocol? { set get }
    func getFriends()
    func friends() -> [IFriend]?
    func showDetail(with friend: IFriend?)
}

class FriendsListPresenter {
    weak var view: FriendsListViewProtocol?
    var interactor: FriendsListInteractorProtocol?
    var router: FriendsListRouterProtocol?
    init(view: FriendsListViewProtocol, interactor: FriendsListInteractorProtocol, router: FriendsListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension FriendsListPresenter: FriendsListPresenterProtocol {
    
    func getFriends() {
        interactor?.loadFriends(completion: { [weak self] result in
            switch result {
            case .success:
                let friends = self?.interactor?.friends()
                self?.view?.updateFriends(friends: friends)
            case .failure(let error):
                self?.view?.showAlert(for: error)
            }
            self?.view?.endRefreshing()
        })
    }
    
    func friends() -> [IFriend]? {
        return interactor?.friends()
    }
    
    func showDetail(with friend: IFriend?) {
        router?.showDetailViewController(friend: friend, service: self.interactor?.friendService)
    }
}
