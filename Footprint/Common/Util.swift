//
//  Util.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//

import Foundation
import SwiftUI
import RealmSwift
import CoreLocation

enum PermissionStatus {
    case allow
    case notYet
    case notAllow
    case unknown
}

class Util {
    static func safeAreaInsets() -> UIEdgeInsets? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)?.safeAreaInsets
    }
    
    static func safeBottom() -> CGFloat {
        return safeAreaInsets()?.bottom ?? 0
    }
    
    static func safeTop() -> CGFloat {
        return safeAreaInsets()?.top ?? 0
    }
    
    static func makeFootprintCopy(_ footprint: FootPrint) -> FootPrint {
        return FootPrint(title: footprint.title, content: footprint.content, images: footprint.images, latitude: footprint.latitude, longitude: footprint.longitude, tag: footprint.tag, peopleWithIds: footprint.peopleWithIds)
    }
    
    static func makePeopleWithCopy(_ peopleWith: PeopleWith) -> PeopleWith {
        return PeopleWith(id: peopleWith.id, name: peopleWith.name, image: peopleWith.image, intro: peopleWith.intro)
    }
    
    static func makeCategoryCopy(_ category: Category) -> Category {
        return Category(tag: category.tag, name: category.name, pinType: category.pinType.pinType(), pinColor: category.pinColor.pinColor())
    }
}


func checkLocationPermission() -> PermissionStatus {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedAlways, .authorizedWhenInUse:
        C.permissionLocation = true
        return .allow
    case .restricted, .notDetermined:
        C.permissionLocation = false
        return .notYet
    case .denied:
        C.permissionLocation = false
        return .notAllow
    default:
        C.permissionLocation = false
        return .unknown
    }
}


//func saveImageToDocumentDirectory(imageName: String, image: UIImage)  {
//    // 1. 이미지를 저장할 경로를 설정해줘야함 - 도큐먼트 폴더,File 관련된건 Filemanager가 관리함(싱글톤 패턴)
//    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
//
//    // 2. 이미지 파일 이름 & 최종 경로 설정
//    let imageURL = documentDirectory.appendingPathComponent(imageName)
//
//    // 3. 이미지 압축(image.pngData())
//    // 압축할거면 jpegData로~(0~1 사이 값)
//    guard let data = image.pngData() else {
//        print("압축이 실패했습니다.")
//        return
//    }
//
//    // 4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기하는 경우
//    // 4-1. 이미지 경로 여부 확인
//    if FileManager.default.fileExists(atPath: imageURL.path) {
//        // 4-2. 이미지가 존재한다면 기존 경로에 있는 이미지 삭제
//        do {
//            try FileManager.default.removeItem(at: imageURL)
//            print("이미지 삭제 완료")
//        } catch {
//            print("이미지를 삭제하지 못했습니다.")
//        }
//    }
//
//    // 5. 이미지를 도큐먼트에 저장
//    // 파일을 저장하는 등의 행위는 조심스러워야하기 때문에 do try catch 문을 사용하는 편임
//    do {
//        try data.write(to: imageURL)
//        print("이미지 저장완료")
//    } catch {
//        print("이미지를 저장하지 못했습니다.")
//    }
//}
//
class ImageManager {
    static let shared = ImageManager()

    func saveImage(image: UIImage, imageName: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return nil
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return nil
        }
        do {
            try data.write(to: directory.appendingPathComponent(imageName)!)
            if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
//                return URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(imageName).path
                return imageName
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
        return nil
    }

    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
