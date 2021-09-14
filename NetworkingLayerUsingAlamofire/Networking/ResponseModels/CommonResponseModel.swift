//
//  CommonResponseModel.swift
//  CommonResponseModel
//
//  Created by VK
//

import Foundation

//Common Response Model for all API with any data
struct CommonResponseModel<T>: Codable where T: Codable {
    let status: Int
    let message: String?
    let data: T
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
}

//Common Response Model for all API with arry of data
struct CommonResponseModelWithDataArray<T>: Codable where T: Codable {
    let status: Int
    let message: String?
    let data: [T]
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
}
