//
//  FriendsListBuilder.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

class TagsBuilder {
    static func build(tagsCollectionViewCell: TagsCell) {
        let presenter = TagsPresenter(view: tagsCollectionViewCell)
        tagsCollectionViewCell.presenter = presenter
    }
}
