//
//  EndPoint.swift
//  NetworkLayerUsingAlamofire
//
//  Created by VK
//

import Foundation

enum Result<NetworkError>{
    case success
    case failure(NetworkError)
}

//Base class for all endpoints
class EndPoint {
    
    fileprivate let TAG = "EndPoint"
    
    //Handle response code
    func handleResponseCode(_ response: HTTPURLResponse) -> Result<NetworkError>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(.authenticationError)
        case 501...599: return .failure(.badRequest)
        default: return .failure(.genricError)
        }
    }
    
    // Common data parsing used in our app - URCommonResponseModel
    func parseData<T: Codable>(data: Data?, response: URLResponse?, error: Error?) -> (T?, NetworkError?) {
        //Check error
        if let error = error?.asAFError {
            switch error {
            case .sessionTaskFailed(let err):
                //Handle no internet condition
                if (err as NSError).code == -1009 {
                    return (nil, .noInternet)
                }
            default:
                break
            }
            return (nil, .custom(message: error.localizedDescription))
        } else if let response = response as? HTTPURLResponse {
            //Check response
            let result = EndPoint().handleResponseCode(response)
            switch result {
            case .success:
                guard let data = data else {
                    return(nil, .emptyResponse)
                }
                do {
                    let responseObject = try JSONDecoder().decode(CommonResponseModel<T>.self, from: data)
                    //If response status is 0 and 1 then only it is success
                    if (responseObject.status == 0 || responseObject.status == 1) {
                        return(responseObject.data, nil)
                    } else if let message = responseObject.message {
                        return (nil,.custom(message: message))
                    } else {
                        return (nil,.genricError)
                    }
                }
                catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print(TAG + "Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print(TAG + "Value '\(value)' not found:", context.debugDescription)
                    print(TAG +  "codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print(TAG +  "Type '\(type)' mismatch:", context.debugDescription)
                    print(TAG + "codingPath:", context.codingPath)
                } catch {
                    print(TAG + "error: ", error)
                }
            case .failure(let networkFailureError):
                return (nil, networkFailureError)
            }
        }
        return (nil, .emptyResponse)
    }
}


