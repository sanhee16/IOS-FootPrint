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
import Combine

@MainActor
class FPMapManager: NSObject, ObservableObject {
    @Injected(\.loadAllNoteUseCase) var loadAllNoteUseCase
    @Injected(\.loadCategoryUseCase) var loadCategoryUseCase
    
    static let shared = FPMapManager()
    private var myLocation: Location? = nil
    
    private var locationManager: CLLocationManager
    @Published var centerPosition: CLLocationCoordinate2D?
    @Published var centerMarkerStatus: MarkerStatus = .stable
    @Published var centerAddress: String = ""
    
    @Published var mapView: GMSMapView
    @Published var markers: [GMSMarker]
    
    @Published var selectedMarker: String? = nil
    
    private var notes: [Note]
    
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
    func moveToLocation(_ location: Location) {
        self.getCurrentLocation()
        
        let zoom: Float = 17.8
        let latitude: Double = location.latitude
        let longitude: Double = location.longitude
        
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
        self.getCurrentLocation()
        guard let myLocation = self.myLocation else { return }
        self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude: myLocation.latitude, longitude: myLocation.longitude))
    }
    
    func loadMarkers() {
        self.deleteMarkers()
        self.markers.removeAll()
        self.notes = self.loadAllNoteUseCase.execute(.latest)
        // multi-marker: Address 기준으로 같은 marker를 grouping
        var group: [String: [Note]] = [:]
        self.notes.forEach { note in
            if group[note.address] == nil {
                group[note.address] = []
            }
            group[note.address]?.append(note)
        }
        
        group.forEach { (key: String, notes: [Note]) in
            let number = notes.count
            let categoryId: String? = number > 1 ? nil : notes.first?.categoryId
            var location: Location? = nil
            
            if let firstItem = notes.first {
                location = Location(latitude: firstItem.latitude, longitude: firstItem.longitude)
            }
            
            var marker: GMSMarker? = nil
            if let location = location, let categoryId = categoryId, let id = notes.first?.id, number == 1 {
                marker = createMarker(location: location, categoryId: categoryId, id: id)
            } else {
                marker = createMarkerWithNumberNoti(
                    location: location,
                    ids: notes.compactMap({ $0.id }),
                    number: number
                )
            }
            
            if let marker = marker {
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
    
    func createMarkerWithNumberNoti(location: Location?, ids: [String], number: Int) -> GMSMarker? {
        guard let location = location else { return nil }
        
        // 마커 생성하기
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))

        let itemSize = CGSize(width: 60, height: 50)
        let markerImage: UIImage? = UIImage(named: "multi_noShadow")?.resizeImageTo(size: itemSize)
        let itemRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
        
        markerImage?.draw(in: itemRect, blendMode: .normal, alpha: 1)
        
        
        guard let finalMarkerImage = markerImage?.resizeImageTo(size: itemSize) else { return nil }
        
        // 컨테이너 뷰 크기를 늘려서 뱃지가 잘리지 않도록 조정
        let newContainerHeight = itemSize.height + 10 // 여유 공간 추가
        let markerContainerView = UIView(frame: CGRect(x: 0, y: 0, width: itemSize.width, height: newContainerHeight))
        
        // 마커 이미지 뷰
        let finalMarkerImageView = UIImageView(image: finalMarkerImage.withRenderingMode(.alwaysOriginal))
        finalMarkerImageView.frame = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
        markerContainerView.addSubview(finalMarkerImageView)
        
        // 숫자 뷰 생성
        let numberViewSize: CGFloat = 20
        let numberView = UIView(frame: CGRect(x: (itemSize.width - numberViewSize) / 2, y: itemSize.height - numberViewSize / 2, width: numberViewSize, height: numberViewSize))
        numberView.backgroundColor = .red // 원하는 배경색
        numberView.layer.cornerRadius = numberViewSize / 2
        numberView.clipsToBounds = true
        
        // 숫자 라벨 생성
        let numberLabel = UILabel(frame: numberView.bounds)
        numberLabel.text = "\(number)"
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont(name: "NanumSquareRoundOTF", size: 14.0) // 폰트 크기 조정 가능
        
        numberView.addSubview(numberLabel)
        markerContainerView.addSubview(numberView)
        
        marker.iconView = markerContainerView
        marker.map = self.mapView
        marker.tracksViewChanges = false
        marker.isTappable = true
        marker.userData = ids
        
        return marker
    }

    func createMarkerWithNumber(location: Location, categoryId: String, id: String) -> GMSMarker? {
        guard let category = self.loadCategoryUseCase.execute(categoryId) else { return nil }
        // 마커 생성하기
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))

        let backgroundSize = CGSize(width: 40, height: 40)
        let itemSize = CGSize(width: 20, height: 20)
        let itemFinalSize = CGSize(width: 40, height: 40)

        let markerImage: UIImage? = UIImage(named: category.icon.imageName)?.resizeImageTo(size: itemSize)?.withTintColor(UIColor.white)
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

        // Create a container view for the marker
        let markerContainerView = UIView(frame: CGRect(x: 0, y: 0, width: backgroundSize.width, height: backgroundSize.height))

        // Create the marker image view
        let finalMarkerImageView = UIImageView(image: finalMarkerImage.withRenderingMode(.alwaysOriginal))
        finalMarkerImageView.frame = CGRect(x: 0, y: 0, width: backgroundSize.width, height: backgroundSize.height)
        markerContainerView.addSubview(finalMarkerImageView)

        // Create a circle view for the number, same size as the background
        let numberView = UIView(frame: CGRect(x: 0, y: 0, width: backgroundSize.width, height: backgroundSize.height))
        numberView.backgroundColor = .red // 원하는 배경색
        numberView.layer.cornerRadius = backgroundSize.width / 2 // 원형으로 만들기
        numberView.clipsToBounds = true

        // Create the label for the number, centered in the number view
        let numberLabel = UILabel(frame: numberView.bounds)
        numberLabel.text = "\(2)" // yourNumber를 원하는 숫자로 변경
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont.boldSystemFont(ofSize: 16) // 필요에 따라 조정

        numberView.addSubview(numberLabel)
        markerContainerView.addSubview(numberView)

        marker.iconView = markerContainerView
        marker.map = self.mapView
        marker.tracksViewChanges = false
        marker.isTappable = true
        marker.userData = [id]
        return marker
    }
    
    func createMarker(location: Location, categoryId: String, id: String) -> GMSMarker? {
        guard let category = self.loadCategoryUseCase.execute(categoryId) else { return nil }
        
        // 마커 생성하기
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        
        let backgroundSize = CGSize(width: 40, height: 40)
        let innerCircleInset: CGFloat = 2
        let itemSize = CGSize(width: 20, height: 20)
        let itemFinalSize = CGSize(width: 40, height: 40) // 크기를 증가시킴
        
        let markerImage: UIImage? = UIImage(named: category.icon.imageName)?.resizeImageTo(size: itemSize)?.withTintColor(UIColor.white)
        
        guard let markerImage = markerImage else { return nil }
        
        // 전체 이미지 그리기 시작
        UIGraphicsBeginImageContextWithOptions(backgroundSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // 흰색 바깥쪽 원 그리기 (테두리)
        context?.setFillColor(UIColor.white.cgColor)
        context?.fillEllipse(in: CGRect(x: 0, y: 0, width: backgroundSize.width, height: backgroundSize.height))
        
        // 색상이 채워진 안쪽 원 그리기
        context?.setFillColor(UIColor(hex: category.color.hex).cgColor)
        context?.fillEllipse(in: CGRect(x: innerCircleInset, y: innerCircleInset, width: backgroundSize.width - 2 * innerCircleInset, height: backgroundSize.height - 2 * innerCircleInset))
        
        // 마커 이미지 그리기
        let itemRect = CGRect(x: (backgroundSize.width - itemSize.width) / 2, y: (backgroundSize.height - itemSize.height) / 2, width: itemSize.width, height: itemSize.height)
        markerImage.draw(in: itemRect, blendMode: .normal, alpha: 1)
        
        let finalMarkerImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let finalMarkerImage = finalMarkerImage?.resizeImageTo(size: itemFinalSize) else { return nil }
        let finalMarkerImageView = UIImageView(image: finalMarkerImage.withRenderingMode(.alwaysOriginal))
        
        marker.iconView = finalMarkerImageView
        marker.map = self.mapView
        marker.tracksViewChanges = false
        marker.isTappable = true
        marker.userData = [id]
        
        return marker
    }

    
    func unSelectMarker() {
        self.selectedMarker = nil
    }
}

extension FPMapManager: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.changeStateSelectedMarker(true, target: nil)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.changeStateSelectedMarker(false, target: position.target)
    }
    
    // 마커 클릭
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let id = marker.userData as? String {
            self.moveToLocation(Location(latitude: marker.position.latitude, longitude: marker.position.longitude))
            self.selectedMarker = id
        }
        return true
    }
}
