//
//  FriendsServiceRequests.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

extension NetworkManager {
    
    func getFriends(completion: @escaping(Result<[ApiFriend], ApiError>) -> Void) {
        self.validatedRequest(.friends, dataType: [ApiFriend].self) { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .error(let error):
                completion(.failure(error))
            }
        }
    }
}
