//
//  CommonApi.swift
//  Footprint
//
//  Created by sandy on 2022/10/08.
//


import Foundation
import Combine
import Alamofire

class APIEventLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "myNetworkLogger")
    
    func requestDidFinish(_ request: Request) {
        print("🛰 NETWORK Reqeust LOG")
        print(request.description)
        
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "")    + "\n"
            + "Method: " + (request.request?.httpMethod ?? "") + "\n"
            + "Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])" + "\n"
        )
        print("Authorization: " + (request.request?.headers["Authorization"] ?? ""))
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("🛰 NETWORK Response LOG")
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
            + "Result: " + "\(response.result)" + "\n"
            + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
        )
    }
}

class CommonApi {
    public static let instance = CommonApi()
    
    private init() {
        
    }
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
    
    func get<T>(
        _ url: String,
        host: String,
        httpBody: Any? = nil,
        parameters: Parameters? = nil,
        headers requestHeaders: [String: String]? = nil
    ) -> AnyPublisher<T, Error> where T: Codable {
        return request(url, method: .get, host: host, httpBody: httpBody, parameters: parameters, headers: requestHeaders)
            .flatMap { (data: T) -> AnyPublisher<T, Error> in
                Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func request<T>(
        _ url: String,
        method: HTTPMethod,
        host: String,
        httpBody: Any? = nil,
        parameters: Parameters? = nil,
        headers requestHeaders: [String: String]? = nil
    ) -> AnyPublisher<T, Error> where T: Codable {
        let future: (() -> Deferred) = { () -> Deferred<Future<T, Error>> in
            var headers: HTTPHeaders = HTTPHeaders()
            headers.add(name: "Content-Type", value: "application/json")
            headers.add(name: "Accept", value: "application/json")
            
            if let headerItems = requestHeaders {
                headerItems.forEach { (key: String, value: String) in
                    headers.add(name: key, value: value)
                }
            }
            
            return Deferred {
                // deferred : 구독이 일어날 때까지 대기상태로 있다가 구독이 일어났을때 publisher가 결정된다.
                // closer안에는 지연 실행할 publisher를 반환한다.
                // 여기서는 Future가 지연 실행할 publisher
                Future<T, Error> { promise in
                    // Future는 비동기 작업할 때 사용하는 Publisher
                    var request = self.session.request(
                        host + url,
                        method: method,
                        parameters: parameters,
                        encoding: URLEncoding.queryString,
                        headers: headers
                    )
                    
                    // body 처리
                    if let data = httpBody,
                       var req = try? request.convertible.asURLRequest() {
                        if let body = try? JSONSerialization.data(withJSONObject: data, options: []) {
                            req.httpBody = body
                        }
                        req.timeoutInterval = 10
                        request = AF.request(req)
                    }
                    print("url: \(host + url)")
                    
                    request
                        .validate(statusCode: 200..<300)
                        .responseDecodable(
                            queue: DispatchQueue.global(qos: .background),
                            completionHandler: {[weak self](response: DataResponse<T, AFError>) in
                                guard self != nil else { return }
                                //                                print("response: \(response)")
                                switch response.result {
                                case .success(let value):
                                    promise(.success(value))
                                    break
                                case .failure(let err):
                                    promise(.failure(err))
                                    break
                                }
                            })
                }
            }
        }
        return future().eraseToAnyPublisher()
    }
    
    
}
