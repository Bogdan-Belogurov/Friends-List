//
//  ApiError.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

struct ApiError: Decodable, Error, LocalizedError {
    
    let error: String?
    let message: String?
    
    var failureReason: String? {
        return self.error
    }
    var errorDescription: String? {
        return self.message
    }
}
