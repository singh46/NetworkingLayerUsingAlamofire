//
//  Router.swift
//  NetworkLayerUsingAlamofire
//
//  Created by VK 
//

import Foundation

public typealias RouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter  {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping RouterCompletion)
    func cancelAllRequest()
}

// Router API based on EndPoint
class Router<EndPoint: EndPointType>: NetworkRouter {
    
    // Make request
    func request(_ route: EndPoint, completion: @escaping RouterCompletion) {
        
        var header = route.headers
        if header == nil {
            header = commonHeader()
        }else {
            header?.merge(commonHeader(), uniquingKeysWith: { (current, _) in current })
        }
        AlamofireWrapper.share.request(url: route.baseURL.appendingPathComponent(route.path), method:  route.method, parameters: route.requestParameter, headers: header) { (response,data, error) in
            completion(data,response, error)
        }
    }
    
    // Get request token for authentication
    func requestToken(_ route: EndPoint, username: String, password: String, completion: @escaping RouterCompletion) {
        AlamofireWrapper.share.authentication(url: route.baseURL.appendingPathComponent(route.path), username: username, password: password, parameters: route.requestParameter, headers: route.headers) { (response,data, error) in
            completion(data,response, error)
        }
    }
    
    // Cancel all ongoing requests
    func cancelAllRequest() {
        AlamofireWrapper.share.cancelAllRequest()
    }
    
    // Cancel one ongoing request with URL
    func cancelAllRequestByUrl(_ route: EndPoint) {
        AlamofireWrapper.share.cancelAllRequestByUrl(url: route.baseURL.appendingPathComponent(route.path))
    }
    
    // Pass common header
    func commonHeader() -> [String: String]
    {
        return ["Content-Type": "application/json;charset=UTF-8", "device_type" : "ios"]
    }
}
