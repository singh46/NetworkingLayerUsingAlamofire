//
//  EndPointType.swift
//  NetworkLayerUsingAlamofire
//
//  Created by VK 
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var method: RequestMethod { get }
    var task: HTTPTask { get }
    var headers: RequestHeaders? { get }
    var path: String { get }
    var requestParameter: [String: Any]? { get}
}
