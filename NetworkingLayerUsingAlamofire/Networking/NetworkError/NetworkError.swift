//
//  NetworkError.swift
//  NetworkLayerUsingAlamofire
//
//  Created by VK 
//

import Foundation

// All possible errors 
public enum NetworkError : Error {
    case invalidRequestURL
    case invalidReponseJson
    case authenticationError
    case serverNotResponding
    case badRequest
    case genricError
    case parameterEncodingFailed
    case emptyResponse
    case noInternet
    case custom(message : String?)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .genricError:
            return NSLocalizedString("Something went wrong", comment: "")
        case .badRequest:
            return NSLocalizedString("Bad Request error", comment: "")
        case .invalidRequestURL:
            return NSLocalizedString("Invalid reques URL", comment: "")
        case .invalidReponseJson:
            return NSLocalizedString("Invalid response", comment: "")
        case .authenticationError:
            return NSLocalizedString("You need to be authenticated first", comment: "")
        case .serverNotResponding:
            return NSLocalizedString("Server not responding", comment: "")
        case .custom(let message):
            return NSLocalizedString(message ?? "Something went wrong", comment: "")
        case .parameterEncodingFailed:
            return NSLocalizedString("Parameter encoding failed.", comment: "")
        case .emptyResponse:
            return NSLocalizedString("Response returned with no data", comment: "")
        case .noInternet:
            return NSLocalizedString("Connection seems iffy. Check your network.", comment: "")
        }
    }
}

extension NetworkError: Equatable {
    public static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.noInternet , .noInternet):
            return true
        case (.invalidReponseJson , .invalidReponseJson):
            return true
        default:
            return false
        }
    }
}
