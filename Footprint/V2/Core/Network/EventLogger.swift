//
//  EventLogger.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

import Foundation
import Alamofire

class EventLogger: EventMonitor {
    let queue = DispatchQueue(label: "com.sandy.OpenSea.networklogger")
    func requestDidFinish(_ request: Request) {
        print("⭐️Reqeust LOG")
        print(request.description)
        
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "")  + "\n"
            + "Method: " + (request.request?.httpMethod ?? "") + "\n"
            + "Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])" + "\n"
        )
        print("Authorization: " + (request.request?.headers["Authorization"] ?? ""))
        print("Body: " + (request.request?.httpBody?.toPrettyPrintedString ?? ""))
    }
    
    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        print("⭐️RESPONSE LOG")
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
            + "Result: " + "\(response.result)" + "\n"
            + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
            + "Data: \(response.data?.toPrettyPrintedString ?? "")"
        )
    }
}
