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

enum MapStatus: String {
    case normal
    case adding
}

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
    
    @Published var selectedMarkers: [String] = []
    @Published var status: MapStatus = .normal
    static var tempNote: TempNote? = nil
    
    private var notes: [NoteEntity]
    private var zoom: Float? = nil
    
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
        addObserver()
    }
    
    @MainActor
    func moveToCurrentLocation() {
        self.getCurrentLocation()
        
        let latitude: Double = self.myLocation?.latitude ?? 37.574187
        let longitude: Double = self.myLocation?.longitude ?? 126.976882
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: (zoom == nil ? 18.0 : mapView.camera.zoom))
        self.zoom = mapView.camera.zoom
        mapView.camera = camera
    }
    
    @MainActor
    func moveToLocation(_ location: Location) {
        self.getCurrentLocation()
        
        let latitude: Double = location.latitude
        let longitude: Double = location.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: (zoom == nil ? 18.0 : mapView.camera.zoom))
        self.zoom = mapView.camera.zoom
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
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(
                didRecieveChangeMapStatusNotification(
                    _:
                )
            ),
            name: .changeMapStatus,
            object: nil
        )
    }

    @objc func didRecieveChangeMapStatusNotification(_ notification: Notification) {
        let getValue = notification.object as! String
        print("didRecieveChangeMapStatusNotification: \(getValue)")
        if let status = MapStatus(rawValue: getValue) {
            self.updateMapStatus(status)
        }
    }

    func updateMapStatus(_ status: MapStatus) {
        print("updateMapStatus: \(status.rawValue)")
        self.status = status
        switch status {
        case .normal:
            Self.tempNote = nil
            NotificationCenter.default.post(name: .isShowTabBar, object: true)
            break
        case .adding:
            NotificationCenter.default.post(name: .isShowTabBar, object: false)
            break
        }
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
        var group: [String: [NoteEntity]] = [:]
        self.notes.forEach { note in
            if group[note.address] == nil {
                group[note.address] = []
            }
            group[note.address]?.append(note)
        }
        print("notes: \(self.notes)")
        
        group.forEach { (key: String, notes: [NoteEntity]) in
            let number = notes.count
            let categoryId: String? = number > 1 ? nil : notes.first?.category.id
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
        let padding: CGFloat = 15.0
        let markerImage: UIImage? = UIImage(named: "multi_noShadow")?.resizeImageTo(size: itemSize)
        let itemRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
        
        markerImage?.draw(in: itemRect, blendMode: .normal, alpha: 1)
        
        
        guard let finalMarkerImage = markerImage?.resizeImageTo(size: itemSize) else { return nil }
        
        // 컨테이너 뷰 크기를 늘려서 뱃지가 잘리지 않도록 조정
        let numberViewSize: CGFloat = 24.0
        let newContainerHeight = itemSize.height + numberViewSize / 2// 여유 공간 추가
        let markerContainerView = UIView(frame: CGRect(x: 0, y: 0, width: itemSize.width + padding * 2, height: newContainerHeight + padding * 2))
        
        // 마커 이미지 뷰
        let finalMarkerImageView = UIImageView(image: finalMarkerImage.withRenderingMode(.alwaysOriginal))
        finalMarkerImageView.frame = CGRect(x: padding, y: padding, width: itemSize.width, height: itemSize.height)
        
        // 그림자 속성 설정
        finalMarkerImageView.layer.shadowColor = Color.dropSahdow_gray_low.cgColor
        finalMarkerImageView.layer.shadowOffset = CGSize(width: 0, height: 13.33) // 그림자 위치
        finalMarkerImageView.layer.shadowRadius = 13.33 // 그림자 반경
        finalMarkerImageView.layer.masksToBounds = false

        markerContainerView.addSubview(finalMarkerImageView)
        
        // 숫자 뷰 생성
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
        finalMarkerImageView.addSubview(numberView)
        
        
        marker.groundAnchor = CGPointMake(0.5, 0.5)
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
        
        marker.groundAnchor = CGPointMake(0.5, 0.5)
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
        let padding: CGFloat = 15.0
        let innerCircleInset: CGFloat = 2
        let itemSize = CGSize(width: 20, height: 20)
        let itemFinalSize = CGSize(width: backgroundSize.width + padding * 2, height: backgroundSize.height + padding * 2)
        
        let markerImage: UIImage? = UIImage(named: category.icon.imageName)?.resizeImageTo(size: itemSize)?.withTintColor(UIColor.white)
        
        guard let markerImage = markerImage else { return nil }
        
        // 전체 이미지 그리기 시작
        UIGraphicsBeginImageContextWithOptions(itemFinalSize, false, 0)
        let context = UIGraphicsGetCurrentContext()

        // 바깥쪽 원에 그림자 설정 (테두리)
        context?.setShadow(offset: CGSize(width: 0, height: 3.33), blur: 13.33, color: Color.dropSahdow_gray_low.cgColor)
        context?.setFillColor(UIColor.white.cgColor)
        context?.fillEllipse(in: CGRect(x: padding, y: padding, width: backgroundSize.width, height: backgroundSize.height))
        
        // 그림자 제거 (안쪽 원과 나머지에 영향을 주지 않도록)
        context?.setShadow(offset: CGSize.zero, blur: 0)

        // 색상이 채워진 안쪽 원 그리기
        context?.setFillColor(UIColor(hex: category.color.hex).cgColor)
        context?.fillEllipse(in: CGRect(x: innerCircleInset + padding, y: innerCircleInset + padding, width: backgroundSize.width - 2 * innerCircleInset, height: backgroundSize.height - 2 * innerCircleInset))

        // 마커 이미지 그리기
        let itemRect = CGRect(x: (backgroundSize.width - itemSize.width) / 2 + padding, y: (backgroundSize.height - itemSize.height) / 2 + padding, width: itemSize.width, height: itemSize.height)
        markerImage.draw(in: itemRect, blendMode: .normal, alpha: 1)
        
        let finalMarkerImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let finalMarkerImage = finalMarkerImage?.resizeImageTo(size: itemFinalSize) else { return nil }
        let finalMarkerImageView = UIImageView(image: finalMarkerImage.withRenderingMode(.alwaysOriginal))
            
        marker.groundAnchor = CGPointMake(0.5, 0.5)
        marker.iconView = finalMarkerImageView
        marker.map = self.mapView
        marker.tracksViewChanges = false
        marker.isTappable = true
        marker.userData = [id]
        
        return marker
    }

    
    func unSelectMarker() {
        self.selectedMarkers = []
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
        if let ids = marker.userData as? [String] {
            //TODO: status 관리 필요! 
            self.moveToLocation(
                Location(
                    latitude: marker.position.latitude /*- (status == .normal ? 0.001 : 0.0)*/,
                    longitude: marker.position.longitude
                )
            )
            self.selectedMarkers = ids
        }
        return true
    }
}
