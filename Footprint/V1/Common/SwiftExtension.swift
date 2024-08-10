//
//  SwiftExtension.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//
import SwiftUI
import SDSwiftUIPack
import RealmSwift
import Combine


extension Int {
    func pinType() -> PinType {
        return PinType(rawValue: self) ?? .star
    }
    
    func pinColor() -> PinColor {
        return PinColor(rawValue: self) ?? .pin2
    }
    
    func getPeopleWith() -> PeopleWith? {
        let realm = R.realm
        let getPeopleWith = realm.objects(PeopleWith.self)
            .filter { peopleWith in
                peopleWith.id == self
            }
            .first
        if let item = getPeopleWith {
            return PeopleWith(id: item.id, name: item.name, image: item.image, intro: item.intro)
        }
        return nil
    }
    
    func getCategory() -> Category? {
        let realm = R.realm
        // 모든 객체 얻기
        let getCategory = realm.objects(Category.self)
            .sorted(byKeyPath: "tag", ascending: true)
            .filter { category in
                category.tag == self
            }
            .first
        if let cate = getCategory {
            return Category(tag: cate.tag, name: cate.name, pinType: cate.pinType.pinType(), pinColor: cate.pinColor.pinColor())
        }
        return nil
    }
    
    func getDate() -> String {
        let timeToDate = Date(timeIntervalSince1970: Double(self)) // 2021-10-13 17:16:15 +0000
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(abbreviation: "KST") // "2018-03-21 18:07:27"
        date.dateFormat = "yyyy/MM/dd"
//        date.dateFormat = "MM월dd일 HH:mm"
        
        let kr = date.string(from: timeToDate)
        return kr
    }
}

extension Optional {
    func unboxAndPublish<T>() -> AnyPublisher<T, Error> {
        if let data = self as? T {
            return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return Fail(error: GoogleError.NotFound).eraseToAnyPublisher()
    }
}

extension Publisher {
    func run(in set: inout Set<AnyCancellable>, next: ((Self.Output) -> Void)? = nil, err errorListener: ((Error) -> Void)? = nil, complete: (() -> Void)? = nil) {
        self.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(err) = completion {
                    errorListener?(err)
                }
                complete?()
            } receiveValue: { value in
                next?(value)
            }
            .store(in: &set)
    }
}

extension Category {
    func image() -> String {
        return self.pinType.pinType().pinWhite
    }
}

extension FootPrint {
    func categoryImage() -> String? {
        return self.tag.getCategory()?.image()
    }
}

extension String {
    func localized(_ args: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: args)
    }
}
