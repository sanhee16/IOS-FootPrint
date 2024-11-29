//
//  DomainRemoteError.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

enum DomainRemoteError: Error {
    case invalidInput
    case dataNotAvailable
    case unauthorized
    case decodeFail
    case unknown
    case noData
    
    var description: String {
        switch self {
        case .invalidInput:
            return "유효하지 않은 입력입니다"
        case .dataNotAvailable:
            return "정보를 불러오지 못했습니다"
        case .unauthorized:
            return "인증에 실패했습니다"
        case .decodeFail:
            return "정보를 불러오지 못했습니다"
        case .unknown:
            return "오류가 발생했습니다"
        case .noData:
            return "결과가 없습니다"
        }
    }
}
