//
//  INetworkManager.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol INetworkManager {
    func getFriends(completion: @escaping(Result<[ApiFriend], ApiError>) -> Void)
}
