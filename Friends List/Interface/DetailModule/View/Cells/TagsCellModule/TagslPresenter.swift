//
//  FriendsListPresenter.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

protocol TagsPresenterProtocol: class {
    func setTags(tags: [String]?)
}

class TagsPresenter {
    weak var view: TagsViewProtocol?
    init(view: TagsViewProtocol) {
        self.view = view
    }
}

extension TagsPresenter: TagsPresenterProtocol {
    func setTags(tags: [String]?) {
        view?.updateViewWithTags(tags: tags)
    }
}
