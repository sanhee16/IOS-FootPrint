//
//  NetworkError.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

import Foundation
import Alamofire

// 네트워크 통신 공통 에러 정의
enum NetworkError: Error {
    case customError(data: Data)
    case serverError
    case parsingError
    case afError(error: AFError)
    case timeoutError
    case unknown
}
