//
//  SettingRepository.swift
//  Footprint
//
//  Created by sandy on 11/8/24.
//

protocol SettingRepository {
    func updateIsShowMarker(_ isShow: Bool)
    func getIsShowMarker() -> Bool
    func updateTripSortType(_ value: Int)
    func getTripSortType() -> Int
    func updateFootprintSortType(_ value: Int)
    func getFootprintSortType() -> Int
}
