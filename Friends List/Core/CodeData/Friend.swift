//
//  Friends.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 20/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation
import CoreData

extension Friend: IFriend {
    
    var eyeColor: EyeColor? {
        get { return EyeColor(rawValue: self.eyeColorString!) ?? .blue }
        set { self.eyeColorString = newValue?.rawValue  }
    }
    
    var gender: Gender? {
        get { return Gender(rawValue: self.genderString!) ?? .male }
        set { self.genderString = newValue?.rawValue  }
    }
    
    var favoriteFruit: FavoriteFruit? {
        get { return FavoriteFruit(rawValue: self.favoriteFruitString!) ?? .banana }
        set { self.favoriteFruitString = newValue?.rawValue  }
    }
    
    static func insertFriends(_ friends: [ApiFriend], in context: NSManagedObjectContext) -> [Friend] {
        
        var insertedFriends = [Friend]()
        
        context.performAndWait {
            
            for friend in friends {
                if let existingFriend = findFriend(with: friend.guid, in: context) {
                    existingFriend.isActive = friend.isActive
                    existingFriend.balance = friend.balance
                    existingFriend.age = Int16(friend.age)
                    existingFriend.eyeColor = friend.eyeColor
                    existingFriend.name = friend.name
                    existingFriend.gender = friend.gender
                    existingFriend.company = friend.company
                    existingFriend.email = friend.email
                    existingFriend.phone = friend.phone
                    existingFriend.address = friend.address
                    existingFriend.about = friend.about
                    existingFriend.latitude = friend.latitude
                    existingFriend.longitude = friend.longitude
                    existingFriend.favoriteFruit = friend.favoriteFruit
                    existingFriend.tags = friend.tags
                    var friendArray: [Int] = []
                    for ownFriend in friend.friends {
                        friendArray.append(ownFriend.id)
                    }
                    existingFriend.friends = friendArray
                    insertedFriends.append(existingFriend)
                } else {
                    guard let newFriend = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as? Friend else {
                        fatalError("Can't insert Document")
                    }
                    
                    newFriend.id = Int16(friend.id)
                    newFriend.guid = friend.guid
                    newFriend.isActive = friend.isActive
                    newFriend.balance = friend.balance
                    newFriend.age = Int16(friend.age)
                    newFriend.eyeColor = friend.eyeColor
                    newFriend.name = friend.name
                    newFriend.gender = friend.gender
                    newFriend.company = friend.company
                    newFriend.email = friend.email
                    newFriend.phone = friend.phone
                    newFriend.address = friend.address
                    newFriend.about = friend.about
                    newFriend.registered = friend.registered
                    newFriend.latitude = friend.latitude
                    newFriend.longitude = friend.longitude
                    newFriend.favoriteFruit = friend.favoriteFruit
                    newFriend.tags = friend.tags
                    
                    var friendArray: [Int] = []
                    for ownFriend in friend.friends {
                        friendArray.append(ownFriend.id)
                    }
                    
                    newFriend.friends = friendArray
                    insertedFriends.append(newFriend)
                }
            }
        }
        
        return insertedFriends
    }
    
    static func findFriend(with id: String,
                             in context: NSManagedObjectContext) -> Friend? {
        let request = FriendsFetchRequester.fetchFriend(with: id)
        
        var foundedFriend: Friend?
        context.performAndWait {
            do {
                let friends = try context.fetch(request)
                assert(friends.count < 2, "Documents with id \(id) more than 1")
                
                if !friends.isEmpty {
                    foundedFriend = friends.first!
                }
            } catch {
                assertionFailure("Can't get document by a fetch. Maybe there is an incorrect fetch")
            }
        }
        
        return foundedFriend
    }
    
    static func fetchFriendPredicate(with id: Int16) -> NSPredicate {
        return NSPredicate(format: "id == \(id)")
    }
    static func fetchFriendNamePredicate(with name: String) -> NSPredicate {
        return NSPredicate(format: "originalFileName contains[c] %@", name)
    }
}

extension Friend: EntityFetchable {
    static var entityName: String = "Friend"
}
