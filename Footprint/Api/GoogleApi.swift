//
//  GoogleApi.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/12.
//

import Combine
import Alamofire
import Foundation
import UIKit

// status code:  https://developers.google.com/maps/documentation/geocoding/requests-geocoding#StatusCodes
public struct GoogleItemResponse<T: Codable>: Codable {
    let status: String?
    let results: T
}

public class GoogleArrayResponse<T: Codable>: Codable {
    let status: String?
    let results: [T]?
    
    init() {
        status = nil
        results = nil
    }
}

public class GoogleErrorResponse: Codable {
    let status: String?
    let error_message: String?
}

class GoogleApi {
    public static let instance = GoogleApi()
    
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
        headers requestHeaders: [String: String]? = nil,
        file: String = #file,
        line: Int = #line,
        function: String = #function
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
                                    print("success: \(value)")
                                    promise(.success(value))
                                    break
                                case .failure(let err):
                                    print("fail: \(err)")
                                    promise(.failure(err))
                                    break
                                }
                            })
                }
            }
        }
        return future().eraseToAnyPublisher()
    }
    
    func get<T>(_ url: String, host: String = C.GEOCODING_HOST, parameters: Parameters? = nil, file: String = #file, line: Int = #line, function: String = #function) -> AnyPublisher<T, Error> where T: Codable {
        return request(url, method: .get, host: host, httpBody: nil, parameters: parameters, file: file, line: line, function: function)
            .flatMap { (data: GoogleItemResponse<T>) -> AnyPublisher<T, Error> in
                Just(data.results).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getArrayUnwrap<T: Codable>(_ url: String, host: String = C.GEOCODING_HOST, parameters: Parameters? = nil, file: String = #file, line: Int = #line, function: String = #function) -> AnyPublisher<[T], Error> {
        return request(url, method: .get, host: host, httpBody: nil, parameters: parameters, file: file, line: line, function: function)
            .flatMap { (data: GoogleArrayResponse<T>) -> AnyPublisher<[T], Error> in
                return data.results.unboxAndPublish()
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: Api
    // https://maps.googleapis.com/maps/api/geocode/json?place_id=\()&key=\(Bundle.main.googleApiKey)
    func getGeocoding(_ placeId: String) -> AnyPublisher<[GeocodingResponse], Error> {
        let key = Bundle.main.geocodingApiKey
        let param = ["language": UserLocale.currentLanguage()] as? Parameters
        return self.getArrayUnwrap("json?place_id=\(placeId)&key=\(key)", host: C.GEOCODING_HOST, parameters: param)
    }
}
