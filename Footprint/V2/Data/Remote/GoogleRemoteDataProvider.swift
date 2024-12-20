//
//  GoogleRemoteDataProvider.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

import Foundation
import Alamofire

class GoogleRemoteDataProvider {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    private func decodeError(_ networkError: NetworkError) -> GoogleNetworkError {
        switch networkError {
        case .customError(let data):
            if let errorResponse: GoogleErrorResponse = try? JSONDecoder().decode(GoogleErrorResponse.self, from: data) {
                return GoogleNetworkError.invalidParameter(message: errorResponse.errorMessage ?? "")
            }
            return GoogleNetworkError.decodeFail
        case .unknown:
            return GoogleNetworkError.unknown
        case .afError(_):
            return GoogleNetworkError.serverError
        default:
            return GoogleNetworkError.unknown
        }
    }
    
    private func get<T>(_ url: String, auth: Bool = false, parameters: Parameters? = nil) async -> Result<T, GoogleNetworkError> where T: Codable {
        return await self.networkService.request(
            url: url,
            auth: auth,
            method: .get,
            headers: [:],
            parameters: parameters,
            httpBody: nil
        ).mapError { apiError in
            self.decodeError(apiError)
        }
    }
}

extension GoogleRemoteDataProvider {
    func fetchGeocoding(_ placeId: String) async -> Result<GoogleGeocodingRemoteResponse<GoogleGeocodingModel>, GoogleNetworkError> {
        // 일반적으로 주소 조회 시 "results" 배열의 한 항목만 반환되지만 주소 쿼리가 모호한 경우 지오코더가 여러 결과를 반환할 수 있습니다.
        let key = Bundle.main.geocodingApiKey
        let param = ["language": UserLocale.currentLanguage()] as? Parameters
        return await self.get("/json?place_id=\(placeId)&key=\(key)", auth: false, parameters: param)
    }
}
