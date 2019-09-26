//
//  NetworkManager.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation
import UIKit

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum NetworkResult <String> {
    case success
    case failure(String)
}

struct NetworkManager: INetworkManager {
    static let environment: NetworkEnvironment = .production
    let router = Router<FriendsListEndPoint>()
    
    fileprivate static func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResult<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 404: return .failure(NetworkResponse.badRequest.rawValue)
        case 401: return .failure(NetworkResponse.authenticationError.rawValue)
        case 400, 402...599: return .failure(NetworkResponse.failed.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    fileprivate static func handleError(data: Data?) -> ApiError? {
        if let responseData = data {
            do {
                let errorResponse = try JSONDecoder().decode(ApiError.self, from: responseData)
                print(errorResponse)
                return errorResponse
            } catch {
                print(error)
                return nil}
        } else {
            return nil
        }
    }
}

extension NetworkManager {
    static func validate<T>(data: Data?, response: URLResponse?, error: Error?, type: T.Type) -> ResponseValidationResult<T> where T: Decodable {
        
        guard error == nil else {
            return .error(error: ApiError(error: "", message: error?.localizedDescription))
        }
        
        guard let response = response as? HTTPURLResponse else {
            return .error(error: ApiError(error: "", message: NetworkResponse.badRequest.rawValue))
        }
        
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
            guard let responseData = data else {
                return .error(error: ApiError(error: "", message: NetworkResponse.noData.rawValue))
            }
            do {
                let apiResponse = try JSONDecoder().decode(type, from: responseData)
                print(apiResponse)
                return .success(data: apiResponse)
            } catch let error {
                print (error)
                return .error(error: ApiError(error: "", message: NetworkResponse.unableToDecode.rawValue))
            }
        case .failure(let networkFailureError):
            if let errorResponse = self.handleError(data: data) {
                return .error(error: errorResponse)
            } else {
                let unknownError = ApiError(error: "", message: networkFailureError)
                return .error(error: unknownError)
            }
        }
    }
}

extension NetworkManager {
    func validatedRequest<T>(_ route: FriendsListEndPoint, dataType: T.Type, completion: @escaping (_ result: ResponseValidationResult<T>) -> Void) where T: Decodable {
        router.request(route) { (data, response, error) in
            let result = NetworkManager.validate(data: data, response: response, error: error, type: dataType)
            completion(result)
        }
    }
}

enum ResponseValidationResult<T> {
    case success(data: T)
    case error(error: ApiError)
}

enum DownloadResponseValidationResult {
    case success(localUrl: URL)
    case error(error: ApiError)
}
