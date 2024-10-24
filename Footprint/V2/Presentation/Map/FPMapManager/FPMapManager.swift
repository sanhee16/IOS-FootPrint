//
//  FPMapManager.swift
//  Footprint
//
//  Created by sandy on 8/15/24.
//

import Foundation
import MapKit
import GoogleMaps
import GooglePlaces
import SwiftUI
import Contacts
import Factory

@MainActor
class FPMapManager: NSObject, ObservableObject {
    @Injected(\.loadNoteUseCase) var loadNoteUseCase
    @Injected(\.loadCategoryUseCase) var loadCategoryUseCase
    
    static let shared = FPMapManager()
    private var myLocation: Location? = nil
    
    private var locationManager: CLLocationManager
    @Published var centerPosition: CLLocationCoordinate2D?
    @Published var centerMarkerStatus: MarkerStatus = .stable
    @Published var centerAddress: String = ""
    
    @Published var mapView: GMSMapView
    @Published var markers: [GMSMarker]
    
    private var notes: [NoteData]
    
    private override init() {
        self.mapView = GMSMapView.init()
        
        self.centerPosition = nil
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = false
        
        self.markers = []
        self.notes = []
        super.init()
        mapView.delegate = self
        
        self.settingMapView()
    }
    
    @MainActor
    func updateMapView() {
        self.mapView = GMSMapView.init()
    }
    
    @MainActor
    func moveToCurrentLocation() {
        self.getCurrentLocation()
        
        let zoom: Float = 17.8
        let latitude: Double = self.myLocation?.latitude ?? 37.574187
        let longitude: Double = self.myLocation?.longitude ?? 126.976882
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView.camera = camera
    }
    
    @MainActor
    func settingMapView() {
        self.moveToCurrentLocation()
        
        // 지도 setting
        mapView.mapType = .normal
        mapView.isIndoorEnabled = false
        mapView.isBuildingsEnabled = false
        mapView.isMyLocationEnabled = true
        
        C.mapView = mapView
    }
    
    
    func didTapMyLocationButton() {
        guard let myLocation = self.myLocation else { return }
        self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude: myLocation.latitude, longitude: myLocation.longitude))
    }
    
    func loadMarkers() {
        self.markers.removeAll()
        self.notes = self.loadNoteUseCase.execute()
        
        self.notes.forEach { note in
            if let marker = createMarker(location: Location(latitude: note.latitude, longitude: note.longitude), categoryId: note.categoryId) {
                self.markers.append(marker)
            }
        }
    }
    
    func deleteMarkers() {
        for marker in markers {
            marker.map = nil
        }
    }
    
    private func getCurrentLocation() {
        if let coor = CLLocationManager().location?.coordinate {
            let latitude = coor.latitude
            let longitude = coor.longitude
            self.myLocation = Location(latitude: latitude, longitude: longitude)
        }
    }
    
    private func changeStateSelectedMarker(_ isDrag: Bool, target: CLLocationCoordinate2D?) {
        self.centerMarkerStatus = isDrag ? .move : .stable
        self.centerPosition = target
        
        guard let target = target else { return }
        
        let location = CLLocation(latitude: target.latitude, longitude: target.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr") //TODO: 언어 바꾸기!
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last
            else { return }
            
            if let postalAddress = address.postalAddress {
                let formatter = CNPostalAddressFormatter()
                let addressString = formatter.string(from: postalAddress)
                
                var result: String = ""
                addressString.split(separator: "\n").forEach { value in
                    result.append(contentsOf: "\(value) ")
                }
                self?.centerAddress = result
            }
        }
    }
    
    func createMarker(location: Location, categoryId: String) -> GMSMarker? {
        guard let category = self.loadCategoryUseCase.execute(categoryId) else { return nil }
        // 마커 생성하기
        // MARK: mix two images!
        // reference: https://stackoverflow.com/questions/32006128/how-to-merge-two-uiimages
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        
        let backgroundSize = CGSize(width: 130, height: 130)
        let itemSize = CGSize(width: 100, height: 100)
        let itemFinalSize = CGSize(width: 22, height: 22)
        let markerImage: UIImage? = UIImage(named: category.icon.imageName)?.resizeImageTo(size: itemSize)
        var backgroundImage: UIImage? = UIImage(named: "mark_background_black")?.resizeImageTo(size: backgroundSize)
        backgroundImage = backgroundImage?.withTintColor(UIColor(hex: category.color.hex), renderingMode: .alwaysTemplate)
        
        guard let markerImage = markerImage, let backgroundImage = backgroundImage else { return nil }
        
        let backgroundRect = CGRect(x: 0, y: 0, width: backgroundSize.width, height: backgroundSize.height)
        let itemRect = CGRect(x: (backgroundSize.width - itemSize.width) / 2, y: (backgroundSize.height - itemSize.height) / 2, width: itemSize.width, height: itemSize.height)
        
        UIGraphicsBeginImageContext(backgroundSize)
        backgroundImage.draw(in: backgroundRect, blendMode: .normal, alpha: 1)
        markerImage.draw(in: itemRect, blendMode: .normal, alpha: 1)
        
        let finalMarkerImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let finalMarkerImage = finalMarkerImage?.resizeImageTo(size: itemFinalSize) else { return nil }
        let finalMarkerImageView = UIImageView(image: finalMarkerImage.withRenderingMode(.alwaysOriginal))
        marker.iconView = finalMarkerImageView
        marker.map = self.mapView
        marker.tracksViewChanges = false
        marker.isTappable = true
        
        return marker
    }
}

extension FPMapManager: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.changeStateSelectedMarker(true, target: nil)
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.changeStateSelectedMarker(false, target: position.target)
    }
}
