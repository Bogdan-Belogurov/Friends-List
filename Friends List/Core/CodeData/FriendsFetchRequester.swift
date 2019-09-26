//
//  FriendsFetchRequester.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 20/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation
import CoreData

internal final class FriendsFetchRequester {
    
    internal static func fetchFriend(with id: String) -> NSFetchRequest<Friend> {
        let request: NSFetchRequest<Friend> = Friend.fetchRequest()
        request.predicate = NSPredicate(format: "guid == %@", id)
        return request
    }
}
