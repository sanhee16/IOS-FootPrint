//
//  AppDelegate.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseCore
import FirebaseFirestore
import GoogleMobileAds
import RealmSwift

//@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate ??
class AppDelegate: UIResponder, UIApplicationDelegate {
    /*
     UISceneSession 객체 = scene의 고유의 런타임 인스턴스를 관리함
     scene을 추적하는 session -> session 안에는 고유한 식별자와 scene의 구성 세부사항이 들어있음
     
     현재 업데이트(iOS 13) 이후
     multi-scene, mutli-window가 가능해짐
     
     AppDelegate가 하는 일 (ios 13이후)
     1. 앱의 가장 중요한 데이터 구조를 초기화 하는 것
     2. 앱의 scene을 환경설정 하는 것
     3. 앱 밖에서 발생한 알림에 대응하는 것
     4. 특정한 scenes, views, view controllers에 한정되지 않고 앱 자체를 타겟하는 이벤트에 대응하는 것
     5. 애플 푸쉬 알림 서브스와 같이 실행 시 요구되는 모든 서비스를 등록하는 것
     */
    var appTerminate: (() -> Void)? = nil
    
    // application의 setup을 여기에서 진행한다.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("application : didFinishLaunchingWithOptions")
        UNUserNotificationCenter.current().delegate = self // notification

        let googleApiKey: String = Bundle.main.googleApiKey
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)

        
        if #available(iOS 11.0, *) {
            // 경고창 배지 사운드를 사용하는 알림 환경 정보를 생성하고, 사용자 동의여부 창을 실행
            let notiCenter =  UNUserNotificationCenter.current()
            notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (didAllow, e) in }
            notiCenter.delegate = self
            // 이 코드는 사용자가 알림을 클릭하여 들어온 이벤트를 전달받기 위한 델리게이트 패턴구조
            // 즉, 알림 센터와 관련하여 뭔가 사건이 발생하면 나(앱 델리게이트) 한테 알려줘 이런 의미임
            /* 클로저 매개변수 설명
             사용자가 메시지 창의 알림 동의 여부를 true / false
             오류 발생시 사용하는 오류 발생 타입의 매개변수 e
             */
        } else {
            // 경고창, 배지, 사운드를 사용하는 알림 환경 정보를 생성하고, 이를 애플리케이션에 저장.
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(setting) // 생성된 정보 애플리케이션에 등록
        }
        
        // FireStore (firebase)
        FirebaseApp.configure()

        //admob
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        // network connection
        NetworkMonitor.shared.startMonitoring()

        // migration
        dbMigration()

        return true
    }
    
    // application이 새로운 scene/window를 제공하려고 할 때 불리는 메소드
    func application(_ application: UIApplication, configurationForConnecting connectionSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectionSceneSession.role)
    }
    
    // 세로모드
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    // 사용자가 scene을 버릴 때 불린다.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("application : didDiscardSceneSessions")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
        self.appTerminate?()
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("applicationDidFinishLaunching")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("userNotificationCenter")
        if notification.request.identifier == "FootprintNoti" { // 로컬 알림 등록시 입력한 식별 아이디를 읽어오는 속성
            //            let userInfo = notification.request.content.userInfo // 유저가 커스텀으로 정의한 정보를 읽어오는 역할
            //            print(userInfo["name"]!) // 딕셔너리 값을 출력
        }
        completionHandler([.banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // user click 이 일어남
        print("userNotificationCenter")
        if response.notification.request.identifier == "FootprintNoti" {
            //            let userInfo = response.notification.request.content.userInfo
            //            print(userInfo["name"]!)
        }
        completionHandler()
    }
}

extension AppDelegate {
    func createDummyData() {
        print("[DB]path= \(Realm.Configuration.defaultConfiguration.fileURL!)");
        
        let useCase = CreateDummyDataUseCase()
        useCase.execute()
    }
    
    func dbMigration() {
        print("[DB] Realm.Configuration.defaultConfiguration: \(Realm.Configuration.defaultConfiguration.schemaVersion)")
//         ✅ schemaVersion 수정
        let config = Realm.Configuration(schemaVersion: 6) { migration, oldSchemaVersion in
            // ✅ 0 -> 1로 업데이트, 새로운 컬럼 추가
            print("[DB] oldSchemaVersion: \(oldSchemaVersion)")
            if oldSchemaVersion < 10 {
                var memberIds: [Int: String] = [:]
                var categoryIds: [Int: String] = [:]
                var footprintIds: [ObjectId: String] = [:]
                
                migration.enumerateObjects(ofType: PeopleWith.className()) { oldObject, newObject in
                    let newID = UUID().uuidString
                    newObject?["newID"] = newID
                    
                    if let oldID = oldObject?["id"] as? Int {
                        memberIds[oldID] = newID
                    }
                }
                
                migration.enumerateObjects(ofType: Category.className()) { oldObject, newObject in
                    let newID = UUID().uuidString
                    
                    if let type = oldObject?["pinType"] as? Int, let color = oldObject?["pinColor"] as? Int, let pinType = PinType(rawValue: type), let pinColor = PinColor(rawValue: color) {
                        newObject?["newColor"] = pinColor.v2Color.rawValue
                        newObject?["newIcon"] = pinType.v2Icon.rawValue
                    } else {
                        newObject?["newColor"] = 0
                        newObject?["newIcon"] = ""
                    }
                    newObject?["newID"] = newID
                    
                    if let oldID = oldObject?["tag"] as? Int {
                        categoryIds[oldID] = newID
                    }
                }
                
                migration.enumerateObjects(ofType: FootPrint.className()) { oldObject, newObject in
                    let newID = UUID().uuidString
                    newObject?["newID"] = newID
                    
                    if let memberOldIDs = oldObject?["peopleWithIds"] as? List<Int> {
                        var newIds: List<String> = List<String>()
                        for oldID in memberOldIDs {
                            if let id = memberIds[oldID] {
                                newIds.append(id)
                            }
                        }
                        newObject?["memberIds"] = newIds
                    }
                    
                    if let categoryOldID = oldObject?["tag"] as? Int {
                        if let categoryNewID = categoryIds[categoryOldID] {
                            newObject!["categoryId"] = categoryNewID
                        }
                    }
                    
                    if let oldID = oldObject?["id"] as? ObjectId {
                        footprintIds[oldID] = newID
                    }
                }
                
                migration.enumerateObjects(ofType: Travel.className()) { oldObject, newObject in
                    let newID = UUID().uuidString
                    newObject?["newID"] = newID
                    
                    
                    
                    if let footprintsOldIDs = oldObject?.dynamicList("footprints").map({ $0.id }) {
//                        let footprintsOldIDs = items.map({ $0.id })
                        var newIds: List<String> = List<String>()
                        footprintsOldIDs.forEach { oldID in
                            if let oldID = oldID as? ObjectId, let id = footprintIds[oldID] {
                                newIds.append(id)
                            }
                        }
                        newObject?["footprintIDs"] = newIds
                    }
                }
                
                
                
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
        print("[DB]path= \(Realm.Configuration.defaultConfiguration.fileURL!)");

    }
}

