//
//  CountryEndPoint.swift
//  CountryEndPoint
//
//  Created by VK
//


import Foundation

//MARK: - For group of similar API's we can create a new class
class CountryEndPoint : EndPoint {
    
    typealias CompletionResult = (_ countries : [Country]?,_ error: NetworkError?) -> Void
    let router = Router<CountryEndPointType>()
    
    //Get all countries
    func getAllCountries(completion: @escaping CompletionResult) {
        //Network Call
        router.request(.getAllCountries, completion: {[weak self] (data, response, error) in
            let parsedData: ([Country]?, NetworkError?)? = self?.parseData(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(parsedData?.0, parsedData?.1)
            }
        })
    }
    
    //Get 10 random countries
    func getTenRandomCountries(completion: @escaping CompletionResult) {
        //Network Call
        router.request(.getTenRandomCountries, completion: {[weak self] (data, response, error) in
            let parsedData: ([Country]?, NetworkError?)? = self?.parseData(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(parsedData?.0, parsedData?.1)
            }
        })
    }
    
    //Get n random countries in sorted orders
    func getRandomCountriesInSortedOrder(count : Int, completion: @escaping CompletionResult) {
        //Network Call
        router.request(.getRandomCountriesInSortedOrder(count: count), completion: {[weak self] (data, response, error) in
            let parsedData: ([Country]?, NetworkError?)? = self?.parseData(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(parsedData?.0, parsedData?.1)
            }
        })
    }
}


public enum  CountryEndPointType : EndPointType {
    
    //Get all countries
    case getAllCountries
    
    //Get 10 random countries
    case getTenRandomCountries
    
    //Get n random countries in sorted orders. Take count as input
    case getRandomCountriesInSortedOrder(count : Int)
    
    
    var baseURL: URL {
        guard let url = URL(string: Constants.EndPoint.baseURL) else{
            fatalError("BaseURL not configured")}
        return url
    }
    
    var path: String {
        switch self {
        case .getAllCountries, .getTenRandomCountries, .getRandomCountriesInSortedOrder:
            return "/api/v1/flag.php"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getAllCountries, .getTenRandomCountries, .getRandomCountriesInSortedOrder:
            return .get
        }
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: RequestHeaders? {
        return nil
    }
    
    var httpBody: Data? {
        return nil
    }
    
    var requestParameter: [String : Any]? {
        
        switch self {
        case .getAllCountries:
            var param = [String: Any]()
            param[APIKeys.count] = 0
            return param
            
        case .getTenRandomCountries:
            var param = [String: Any]()
            param[APIKeys.count] = 10
            return param
            
        case .getRandomCountriesInSortedOrder(let count):
            var param = [String: Any]()
            param[APIKeys.count] = count
            return param
        }
    }
    
    struct APIKeys {
        static let count = "count"
        static let sorted = "sorted"
    }
}
