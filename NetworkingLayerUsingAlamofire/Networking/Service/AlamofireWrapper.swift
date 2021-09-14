//
//  AlamofireWrapper.swift
//  NetworkLayerUsingAlamofire
//
//  Created by VK
//

import Foundation
import Alamofire

public typealias AFRequestCompletion = (HTTPURLResponse?, Data?, AFError?) -> Void

// Wrapper on top of Alamofire
class AlamofireWrapper {
    
    fileprivate let TAG = "AlamofireWrapper"
    static let share = AlamofireWrapper()
    private init() {}
    
    let session : Session = {
        let evaluators: [String: ServerTrustEvaluating] = [
            "*.example.com": PinnedCertificatesTrustEvaluator()
        ]
        let manager = WildcardServerTrustPolicyManager(evaluators: evaluators)
        let configuration = URLSessionConfiguration.af.default
        return Session(configuration: configuration, serverTrustManager: manager)
    }()
    
    // Initiate Request
    func request(url : URL, method : RequestMethod, parameters : [String: Any]?, headers : RequestHeaders?, completion: @escaping AFRequestCompletion) {
        
        var headersValue : HTTPHeaders?
        if let headers = headers {
            headersValue = HTTPHeaders.init(headers)
        }
        
        let method = HTTPMethod.init(rawValue: method.rawValue)
        
        if method == .get {
            let request = session.request(url, method: method , parameters: parameters, encoding: URLEncoding(destination: .methodDependent, arrayEncoding: .brackets, boolEncoding: .literal), headers: headersValue)
            request.response{ response in
               // _ = request.debugLog()
                self.printResponse(response: response, url: url)
                //Capture error from afnetwork here
                var error: AFError?
                switch response.result {
                case .failure(let err):
                    error = err
                default: break
                }
                completion(response.response, response.data, error)
            }
            
        }else  if (method == .post ||  method == .put || method == .delete) {
            let  request = session.request(url, method: method , parameters: parameters, encoding: JSONEncoding.default, headers: headersValue)
            request.response{ response in
                self.printResponse(response: response, url: url)
                //Capture error from afnetwork here
                var error: AFError?
                switch response.result {
                case .failure(let err):
                    error = err
                default: break
                }
                completion(response.response, response.data, error)
            }
        }
    }
    
    // Print Response
    fileprivate func printResponse(response : DataResponse<Optional<Data>, AFError>, url : URL) {
        print("\n\n")
        debugPrint("===== Response Start \(url) =====")
        debugPrint(response)
        debugPrint("===== Response End \(url) =====")
        print("\n\n")
    }
    
    
    // Cancel All Requests
    func cancelAllRequest() {
        session.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    // Cancel All Requests with URL
    func cancelAllRequestByUrl(url: URL) {
        session.session.getTasksWithCompletionHandler {(sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach {
                
                print(self.TAG + "on going request URL : \(url.absoluteString)")
                if ($0.originalRequest?.url == url) {
                    print(self.TAG + " Cancel request with URL : \(url.absoluteString)")
                    $0.cancel()
                }
            }
        }
    }
    
    func authentication(url : URL, username : String, password : String, parameters : [String: Any]?, headers : RequestHeaders?, completion: @escaping AFRequestCompletion) {
        
        var headersValue : HTTPHeaders?
        if let headers = headers {
            headersValue = HTTPHeaders.init(headers)
        }
        
        session.request(url,method: .post,parameters: parameters, headers: headersValue).authenticate(username: username, password: password).response{
            response in
            self.printResponse(response: response, url: url)
            //Capture error from afnetwork here
            var error: AFError?
            switch response.result {
            case .failure(let err):
                error = err
            default: break
            }
            completion(response.response, response.data, error)
        }
    }
}

// For accepting wildcard certificate
class WildcardServerTrustPolicyManager: ServerTrustManager {
    override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
        if let policy = evaluators[host] {
            return policy
        }
        var domainComponents = host.split(separator: ".")
        if domainComponents.count > 2 {
            domainComponents[0] = "*"
            let wildcardHost = domainComponents.joined(separator: ".")
            return evaluators[wildcardHost]
        }
        return nil
    }
}

// To print curl request
extension Request {

    public func debugLog() -> Self {
#if DEBUG
        cURLDescription(calling: { (curl) in
            debugPrint("================= Request Start ======================")
            print(curl)
            debugPrint("================= Request End ======================")
        })
#endif
        return self
    }
}
