//
//  Router.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 19/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
public typealias NetworkRouterDownloadCompletion = (_ fileUrl: URL?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkRouter: class {
    associatedtype EndPoint: IEndPoint
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func downloadRequest(_ route: EndPoint, completion: @escaping NetworkRouterDownloadCompletion)
}

class Router<EndPoint: IEndPoint>: NetworkRouter {
    
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        DispatchQueue.global().async {
            let session = URLSession.shared
            do {
                let request = try self.buildRequest(from: route)
                self.task = session.dataTask(with: request, completionHandler: { data, response, error in
                    if error != nil {
                        completion(nil, nil, error)
                    }
                    if let response = response as? HTTPURLResponse {
                        completion(data, response, error)
                    }
                })
            } catch {
                completion(nil, nil, error)
            }
            self.task?.resume()
        }
    }
    
    func downloadRequest(_ route: EndPoint, completion: @escaping NetworkRouterDownloadCompletion) {
        DispatchQueue.global().async {
            let session = URLSession.shared
            do {
                let request = try self.buildRequest(from: route)
                self.task = session.downloadTask(with: request, completionHandler: { localUrl, response, error in
                    if error != nil {
                        completion(nil, nil, error)
                    }
                    if let response = response as? HTTPURLResponse {
                        completion(localUrl, response, error)
                    }
                })
            } catch {
                completion(nil, nil, error)
            }
            self.task?.resume()
        }
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = prepareRequest(route.baseURL.appendingPathComponent(route.path), method: route.httpMethod)
        
        do {
            switch route.task {
            case .request:
                break
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate func prepareRequest(_ url: URL, method: HTTPMethod = .get) -> URLRequest {
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 15.0)
        request.httpMethod = method.rawValue
        return request
    }
}
