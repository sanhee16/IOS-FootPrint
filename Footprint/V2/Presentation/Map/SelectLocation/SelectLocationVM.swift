//
//  SelectLocationVM.swift
//  Footprint
//
//  Created by sandy on 8/13/24.
//

import Foundation
import Combine
import RealmSwift
import GoogleMaps
import GooglePlaces
import CoreLocation
import Contacts

enum MarkerStatus {
    case stable
    case move
    
    var image: String {
        switch self {
        case .stable:
            return "State=able"
        case .move:
            return "State=move"
        }
    }
    
    var size: CGSize {
        switch self {
        case .stable:
            return CGSize(width: 46, height: 54)
        case .move:
            return CGSize(width: 46, height: 72)
        }
    }
}

class SelectLocationVM: BaseViewModel {
    private var locationManager: CLLocationManager

    @Published var selectedMarker: GMSMarker? = nil
    @Published var centerMarkerStatus: MarkerStatus = .stable
    @Published var centerAddress: String = ""
    var myLocation: Location? = nil
    
    var centerPosition: CLLocationCoordinate2D?
    private var allFootprints: [FootPrint] = []
    
    override init() {
        self.centerPosition = nil
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = false
        super.init()
        self.getCurrentLocation()
    }
    
    func onAppear() {
        
    }
    
    func setLocation(location: Location) {
        self.centerPosition = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    private func getCurrentLocation() {
        if let coor = locationManager.location?.coordinate {
            let latitude = coor.latitude
            let longitude = coor.longitude
            print("위도 :\(latitude), 경도: \(longitude)")
            self.myLocation = Location(latitude: latitude, longitude: longitude)
        }
    }
    
    //MARK: MAP
    func createMapView() -> GMSMapView {
        if let mapView = C.mapView {
            return mapView
        }
        let zoom: Float = 17.8
        print("[MAP VIEW] createMapView")
        
        let latitude: Double = self.centerPosition?.latitude ?? self.myLocation?.latitude ?? 0.0
        let longitude: Double = self.centerPosition?.longitude ?? self.myLocation?.longitude ?? 0.0
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // 지도 setting
        // https://developers.google.com/maps/documentation/ios-sdk/controls
        mapView.isIndoorEnabled = false
        mapView.isMyLocationEnabled = true
        mapView.isBuildingsEnabled = false
        mapView.settings.compassButton = true
        
        return mapView
    }
    
    func changeStateSelectedMarker(_ isDrag: Bool, target: CLLocationCoordinate2D?) {
        self.centerMarkerStatus = isDrag ? .move : .stable
        self.centerPosition = target
        
        guard let target = target else { return }
        
        let location = CLLocation(latitude: target.latitude, longitude: target.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last
            else { return }
            
            if let postalAddress = address.postalAddress {
                let formatter = CNPostalAddressFormatter()
                let addressString = formatter.string(from: postalAddress)
                
                print("addressString: \(addressString)")
                var result: String = ""
                addressString.split(separator: "\n").forEach { value in
                    result.append(contentsOf: "\(value) ")
                }
                self?.centerAddress = result
                print("result: \(result)")
            }
        }
    }
}
