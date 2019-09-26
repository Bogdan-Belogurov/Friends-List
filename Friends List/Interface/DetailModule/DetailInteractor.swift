//
//  FriendsListInteractor.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 23/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol DetailInteractorProtocol: class {
    var friendService: IFriendsService? { get set }
    func friend(with id: Int16) -> IFriend?
    func formatedBalance(_ balance: String) -> String?
    func formatedDate(_ date: String) -> String?
    func formatedCoordinate(latitude: Double?, longitude: Double?) -> String?
}

class DetailInteractor {
    var friendService: IFriendsService?
    init(service: IFriendsService?) {
        self.friendService = service
    }
}

extension DetailInteractor: DetailInteractorProtocol {
    func friend(with id: Int16) -> IFriend? {
        return friendService?.friend(with: id)
    }
    
    func formatedBalance(_ balance: String) -> String? {
        let balanceArray = balance.components(separatedBy: ".")
        if balanceArray.last == "0" {
            if let balance = balanceArray.first {
                return balance
            }
        } else {
            return balance
        }
        return nil
    }
    
    func formatedDate(_ date: String) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm dd.MM.yy"

        if let newDate = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: newDate)
        } else {
           return "There was an error decoding the string"
        }
    }
    
    func formatedCoordinate(latitude: Double?, longitude: Double?) -> String? {
        guard let latitude = latitude, let longitude = longitude else { return "No coordinate"}
        let latDegrees = abs(Int(latitude))
        let latMinutes = abs(Int((latitude * 3600).truncatingRemainder(dividingBy: 3600) / 60))
        let latSeconds = Double(abs((latitude * 3600).truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)))

        let lonDegrees = abs(Int(longitude))
        let lonMinutes = abs(Int((longitude * 3600).truncatingRemainder(dividingBy: 3600) / 60))
        let lonSeconds = Double(abs((longitude * 3600).truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60) ))
        return "\(String(format:"%d° %d' %.4f\" %@", latDegrees, latMinutes, latSeconds, latitude >= 0 ? "N" : "S")), \(String(format:"%d° %d' %.4f\" %@", lonDegrees, lonMinutes, lonSeconds, longitude >= 0 ? "E" : "W"))"
    }
}
