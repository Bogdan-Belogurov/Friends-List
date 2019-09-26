//
//  IFriendsService.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol IFriendsService {
    func friends() -> [IFriend]?
    func friend(with id: Int16) -> IFriend?
    func getFriends(completion: @escaping(Result<[IFriend]?, ApiError>) -> Void)
    func deleteAllFriendsCashe()
}
