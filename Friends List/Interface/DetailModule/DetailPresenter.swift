//
//  FriendsListPresenter.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

protocol DetailPresenterProtocol: class {
    var router: DetailRouterProtocol? { get set }
    func viewDidLoad()
    func getFriend(id: Int) -> IFriend?
    func showDetail(with friend: IFriend?)
    func showMailView(email: String)
    func makeCall(number: String)
    func formatedBalance(_ balance: String) -> String?
    func formatedDate(_ date: String) -> String?
    func formatedCoordinate(latitude: Double?, longitude: Double?) -> String?
    func openCoordinateInMap(latitude: Double?, longitude: Double?)
}

class DetailPresenter {
    weak var view: DetailViewProtocol?
    var interactor: DetailInteractorProtocol?
    var router: DetailRouterProtocol?
    var friend: IFriend?
    init(view: DetailViewProtocol, interactor: DetailInteractorProtocol, router: DetailRouterProtocol, friend: IFriend?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.friend = friend
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        view?.updateViewWithFriend(friend: self.friend)
    }
    
    func getFriend(id: Int) -> IFriend? {
        return interactor?.friend(with: Int16(id))
    }
    
    func showDetail(with friend: IFriend?) {
        router?.showDetailViewController(friend: friend, service: self.interactor?.friendService)
    }
    
    func showMailView(email: String) {
        router?.showMailView(email: email)
    }
    
    func makeCall(number: String) {
        router?.makeCall(number: number)
    }
    
    func formatedBalance(_ balance: String) -> String? {
        return interactor?.formatedBalance(balance)
    }
    
    func formatedDate(_ date: String) -> String? {
        return interactor?.formatedDate(date)
    }
    
    func formatedCoordinate(latitude: Double?, longitude: Double?) -> String? {
        return interactor?.formatedCoordinate(latitude: latitude, longitude: longitude)
    }
    
    func openCoordinateInMap(latitude: Double?, longitude: Double?) {
        router?.openCoordinateInMap(latitude: latitude, longitude: longitude)
    }
}
