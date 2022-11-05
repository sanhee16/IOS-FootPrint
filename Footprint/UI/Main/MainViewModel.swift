//
//  MainViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import Foundation
import Combine
import CoreLocation


class MainViewModel: BaseViewModel {
    private var api: Api = Api.instance
    var locationManager: CLLocationManager
    var myLocation: CLLocation? = nil
    
    override init(_ coordinator: AppCoordinator) {
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        super.init(coordinator)
    }
    
    func onAppear() {
        switch checkLocationPermission() {
        case .allow:
            getCurrentLocation()
        default:
            break
        }
    }
    
    func onClickAddFootprint() {
        self.coordinator?.presentAddFootprintView()
    }
    
    func onClickSetting() {
        
    }
    
    private func getCurrentLocation() {
        if let coor = locationManager.location?.coordinate {
            let latitude = coor.latitude
            let longitude = coor.longitude
            print("위도 :\(latitude), 경도: \(longitude)")
            self.myLocation = CLLocation(latitude: latitude, longitude: longitude)
            print("myLocation :\(myLocation)")
        }
    }
}
