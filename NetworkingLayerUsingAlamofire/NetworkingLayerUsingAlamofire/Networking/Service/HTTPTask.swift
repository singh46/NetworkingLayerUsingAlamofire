//
//  HTTPTask.swift
//  NetworkLayerUsingAlamofire
//
//  Created by VK 
//

import Foundation

public typealias RequestHeaders = [String:String]
public typealias Parameters = [String:Any]

public enum HTTPTask {
    case request
    case requestParameters(urlParameters: Parameters)
    case requestParametersWithHeaders(urlParameters: Parameters,additionHeaders: RequestHeaders)
}
