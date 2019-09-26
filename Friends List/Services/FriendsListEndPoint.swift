//
//  FriendsListEndPoint.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case production
}

public enum FriendsListEndPoint {
    case friends
}

extension FriendsListEndPoint: IEndPoint {
    
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "https://www.dropbox.com/s/s8g63b149tnbg8x"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .friends:
            return "/users.json"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .friends:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {

        case .friends:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding,
                                                urlParameters: ["dl": "1"],
                                                additionHeaders: headers)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .friends:
            return ["Content-Type": "application/json"]
        }
    }
}
