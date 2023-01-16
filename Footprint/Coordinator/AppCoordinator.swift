//
//  AppCoordinator.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import SwiftUI

class AppCoordinator: Coordinator, Terminatable {
    // UIWindow = 화면에 나타나는 View를 묶고, UI의 배경을 제공하고, 이벤트 처리행동을 제공하는 객체 = View들을 담는 컨테이너
    let window: UIWindow
    
    init(window: UIWindow) { // SceneDelegate에서 호출
        self.window = window
        super.init() // Coordinator init
        let navigationController = UINavigationController()
        self.navigationController = navigationController // Coordinator의 navigationController
        self.window.rootViewController = navigationController // window의 rootViewController
        window.makeKeyAndVisible()
    }
    
    // Terminatable
    func appTerminate() {
        print("app Terminate")
        for vc in self.childViewControllers {
            print("terminate : \(type(of: vc))")
            (vc as? Terminatable)?.appTerminate()
        }
        if let navigation = self.navigationController as? UINavigationController {
            for vc in navigation.viewControllers {
                (vc as? Terminatable)?.appTerminate()
            }
        } else {
            
        }
        print("terminate : \(type(of: self.navigationController))")
        (self.navigationController as? Terminatable)?.appTerminate()
    }
    
    //MARK: Start
    func startSplash() {
        let vc = SplashView.vc(self)
        self.present(vc, animated: true)
    }
    
    //MARK: Present
    func presentMain() {
        let vc = MainView.vc(self)
        self.present(vc, animated: false)
    }
    
    func presentAddFootprintView(location: Location, type: AddFootprintType, onDismiss: @escaping ()->()) {
        let vc = AddFootprintView.vc(self, location: location, type: type)
        self.present(vc, animated: true, onDismiss: onDismiss)
    }
    
    func presentMultiSelectGalleryView(onClickItem: (([GalleryItem]) -> ())?) {
        let vc = MultiSelectGalleryView.vc(self, onClickItem: onClickItem)
        self.present(vc, animated: true)
    }
    
    func presentSingleSelectGalleryView(onClickItem: ((GalleryItem) -> ())?) {
        let vc = SingleSelectGalleryView.vc(self, onClickItem: onClickItem)
        self.present(vc, animated: true)
    }
    
    func presentAlertView(_ type: AlertType, title: String?, description: String?, callback: ((Bool) -> ())?) {
        let vc = AlertView.vc(self, type: type, title: title, description: description, callback: callback)
        self.present(vc, animated: false)
    }
    
    func presentShowFootPrintView(_ location: Location, onDismiss: @escaping ()->()) {
        let vc = ShowFootPrintView.vc(self, location: location)
        self.present(vc, animated: true, onDismiss: onDismiss)
    }
    
    func presentAddCategoryView(type: AddCategoryType, onEraseCategory: (()->())? = nil, onDismiss: @escaping ()->()) {
        let vc = AddCategoryView.vc(self, type: type, onEraseCategory: onEraseCategory, completion: nil)
        self.present(vc, animated: true, onDismiss: onDismiss)
    }
    
    func presentShowImageView(_ imageIdx: Int, images: [UIImage]) {
        let vc = ShowImageView.vc(self, imageIdx: imageIdx, images: images)
        self.present(vc, animated: true)
    }
    
    func presentSettingView() {
        let vc = SettingView.vc(self)
        self.present(vc, animated: false)
    }
    
    func presentCheckPermission() {
        let vc = CheckPermissionView.vc(self)
        self.present(vc, animated: false)
    }
    
    func presentDevInfoView() {
        let vc = DevInfoView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentFootprintListView() {
        let vc = FootprintListView.vc(self)
        self.present(vc, animated: false)
    }
    
    func presentPeopleWithSelectorView(type: PeopleWithEditType) {
        let vc = PeopleWithSelectorView.vc(self, type: type)
        self.present(vc, animated: false)
    }
    
    func presentPeopleEditView(_ peopleEditStruct: PeopleEditStruct, callback: @escaping ((Int?) -> ())) {
        let vc = PeopleEditView.vc(self, peopleEditStruct: peopleEditStruct, callback: callback)
        self.present(vc, animated: false)
    }
    
    func presentFootprintListFilterView(onDismiss: @escaping ()->()) {
        let vc = FootprintListFilterView.vc(self)
        self.present(vc, animated: false, onDismiss: onDismiss)
    }
    
    func presentTravelListView() {
        let vc = TravelListView.vc(self)
        self.present(vc, animated: false)
    }
    
    func presentEditTravelView(_ type: EditTravelType, onDismiss: (()->())? = nil) {
        let vc = EditTravelView.vc(self, type: type)
        self.present(vc, animated: true, onDismiss: onDismiss)
    }
    
    func presentSelectFootprintsView(selectedList: [FootPrint], callback: @escaping ([FootPrint])->()) {
        let vc = SelectFootprintsView.vc(self, selectedList: selectedList, callback: callback)
        self.present(vc, animated: true)
    }
    
    func presentPeopleWithListView() {
        let vc = PeopleWithListView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentCategorySelectorView(type: CategorySelectorType) {
        let vc = CategorySelectorView.vc(self, type: type)
        self.present(vc, animated: true)
    }
    
    func presentShowTravelView(travel: Travel, onDismiss: @escaping ()->()) {
        let vc = ShowTravelView.vc(self, travel: travel)
        self.present(vc, animated: true, onDismiss: onDismiss)
    }
    
    //MARK: Change
    func changeAddFootprintView(location: Location, type: AddFootprintType, onDismiss: @escaping ()->()) {
        let vc = AddFootprintView.vc(self, location: location, type: type)
        self.change(vc, animated: true, onDismiss: onDismiss)
    }
}
