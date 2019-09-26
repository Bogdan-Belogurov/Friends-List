//
//  IEndPoint.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol IEndPoint {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
