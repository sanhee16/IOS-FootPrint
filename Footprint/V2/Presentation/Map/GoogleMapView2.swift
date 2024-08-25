////
////  GoogleMapView2.swift
////  Footprint
////
////  Created by sandy on 8/10/24.
////
//
//import SwiftUI
//import SDSwiftUIPack
//import MapKit
//import GoogleMaps
//
//struct GoogleMapView2: UIViewRepresentable {
//    var vm: MapVM2
//    
//    init(vm: MapVM2) {
//        self.vm = vm
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(vm: self.vm)
//    }
//    
//    private let zoom: Float = 17.8
//    
//    func makeUIView(context: Self.Context) -> GMSMapView {
//        guard let mapView = C.mapView else {
//            let mapView = vm.createMapView()
//            mapView.delegate = context.coordinator
//            C.mapView = mapView
//            vm.loadAllMarkers()
//            return mapView
//        }
//        
//        mapView.delegate = context.coordinator
//        
//        vm.loadAllMarkers()
//        
//        return mapView
//    }
//    
//    func updateUIView(_ mapView: GMSMapView, context: Context) {
//        
//    }
//    
//    class Coordinator: NSObject, GMSMapViewDelegate {
//        var vm: MapVM2
//        
//        init(vm: MapVM2) {
//            print("[SD] Coordinator init")
//            self.vm = vm
//        }
//        
//        // 구글 마커 클릭
//        func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
//            print("[SD] didTapPOIWithPlaceID")
//            // 클릭하면 장소의 이름과 placeId가 나옴!
////            var newName = name
////            if let newLineIdx = name.firstIndex(of: "\n") {
////                newName.removeSubrange(newLineIdx...)
////            }
////            vm.removeSelectedMarker()
////            vm.drawSelectedMarker(Location(latitude: location.latitude, longitude: location.longitude))
//            //            vm.addNewMarker(Location(latitude: location.latitude, longitude: location.longitude), name: newName, placeId: placeID)
//        }
//        
//        
//        // 구글 마커 외에 아무데나 클릭
//        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
////            let location = Location(latitude: marker.position.latitude, longitude: marker.position.longitude)
////            if vm.selectedMarker == marker {
////                vm.addNewMarker(location)
////            } else {
////                vm.removeSelectedMarker()
////                vm.onTapMarker(location)
////            }
//            return true
//        }
//        
//        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
////            vm.removeSelectedMarker()
////            vm.drawSelectedMarker(Location(latitude: coordinate.latitude, longitude: coordinate.longitude))
//            //            vm.addNewMarker(Location(latitude: coordinate.latitude, longitude: coordinate.longitude))
//        }
//        
//        func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
//            
//        }
//        
//        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//            vm.changeStateSelectedMarker(true, target: nil)
//        }
//
//        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//            vm.changeStateSelectedMarker(false, target: position.target)
//        }
//    }
//}
