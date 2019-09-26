//
//  ApiFriend.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

struct ApiFriend: Codable {
    let id: Int
    let guid: String
    let isActive: Bool
    let balance: String
    let age: Int
    let eyeColor: EyeColor
    let name: String
    let gender: Gender
    let company, email, phone, address: String
    let about, registered: String
    let latitude, longitude: Double
    let tags: [String]
    let friends: [OwnFriends]
    let favoriteFruit: FavoriteFruit
}

enum EyeColor: String, Codable {
    case blue
    case brown
    case green
}

enum FavoriteFruit: String, Codable {
    case apple
    case banana
    case strawberry
}

struct OwnFriends: Codable {
    let id: Int
}

enum Gender: String, Codable {
    case female
    case male
}

protocol IFriend {
    var id: Int16 { get set }
    var guid: String? { get set }
    var isActive: Bool { get set }
    var balance: String? { get set }
    var age: Int16 { get set }
    var eyeColor: EyeColor? { get set }
    var name: String? { get set }
    var gender: Gender? { get set }
    var company: String? { get set }
    var email: String? { get set }
    var phone: String? { get set }
    var address: String? { get set }
    var about: String? { get set }
    var registered: String? { get set }
    var latitude: Double { get set }
    var longitude: Double { get set }
    var tags: [String]? { get set }
    var friends: [Int]? { get set }
    var favoriteFruit: FavoriteFruit? { get set }
}
