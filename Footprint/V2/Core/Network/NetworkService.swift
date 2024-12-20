//
//  NetworkService.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

import Foundation
import Alamofire

class NetworkService {
    let reachabilityManager = NetworkReachabilityManager()
    let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 5 * 60
        configuration.waitsForConnectivity = true
        
        return Session(
            configuration: configuration
        )
    }()
    
    var host: String
    
    init(host: String) {
        self.host = host
    }
}


extension NetworkService {
    func request<T>(
        url: String,
        auth: Bool,
        method: HTTPMethod,
        headers requestHeaders: [String: String]? = nil,
        parameters: Parameters? = nil,
        httpBody: Any? = nil
    ) async -> Result<T, NetworkError> where T: Codable {
        var headers: HTTPHeaders = HTTPHeaders()
        headers.add(name: "content-Type", value: "application/json")
        headers.add(name: "accept", value: "application/json")
        
        if let headerItems = requestHeaders {
            headerItems.forEach { (key: String, value: String) in
                headers.add(name: key, value: value)
            }
        }
        
        let baseURL = host + url
        var request = self.session
            .request(baseURL, method: method, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
        
        if let data = httpBody, var req = try? request.convertible.asURLRequest() {
            if let body = try? JSONSerialization.data(withJSONObject: data, options: []) {
                req.httpBody = body
            }
            request = AF.request(req)
        }
        
        let dataTask = request
            .cURLDescription { description in
                print(description)
            }
            .validate(statusCode: 200..<300)
            .serializingDecodable(T.self)


        switch await dataTask.result {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            print("------------🔺FAIL🔺------------")
            print("🔺\(error)")
            print("---------------------------------")
            if let data = await dataTask.response.data {
                return .failure(NetworkError.customError(data: data))
            }
            return .failure(NetworkError.afError(error: error))
        }
    }
}
