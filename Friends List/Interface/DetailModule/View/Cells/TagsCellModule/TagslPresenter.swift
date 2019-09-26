//
//  FriendsListPresenter.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

protocol TagsPresenterProtocol: class {
    func getTags()
}

class TagsPresenter {
    weak var view: TagsViewProtocol?
    var tags: [String]?
    init(view: TagsViewProtocol, tags: [String]?) {
        self.view = view
        self.tags = tags
    }
}

extension TagsPresenter: TagsPresenterProtocol {
    func getTags() {
        view?.updateViewWithTags(tags: self.tags)
    }
}

