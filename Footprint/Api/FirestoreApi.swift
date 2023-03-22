//
//  File.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/03/22.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseFirestore

class FirestoreApi {
    static let shared = FirestoreApi()
    
    private let fs: Firestore
    private let premiumTierRef: CollectionReference
    
    init() {
        self.fs = Firestore.firestore()
        self.premiumTierRef = self.fs.collection("FreeTier")
    }
    
    
    /// premium 가져오기
    /// - Parameters:
    ///   - documentID: 가져올 id
    ///   - completionHandler:성공시 작업
    func getPremiumTier(documentID: String, completionHandler: @escaping ((_ item: PremiumModel?) -> ())) {
        print("getPremiumTier: \(documentID)")
        premiumTierRef.document(documentID).getDocument {document, err in
            print("[complete] getPremiumTier: \(documentID)")
            print("[complete] getPremiumTier: \(err)")
            guard let document = document else {
                print("Firestore>> document is nil")
                completionHandler(nil)
                return
            }
            
            if let item = try? document.data(as: PremiumModel.self) {
                print("Firestore>>", #function, item.documentID!, item)
                completionHandler(item)
                return
            } else {
                completionHandler(nil)
                return
            }
        }
    }
    
    
    /// documentID를 찾아 해당하는 내용의 기존 데이터를 새로운 구조체 인스턴스의 데이터로 교체
    /// - Parameters:
    ///   - documentID: 교체할 documentID
    ///   - request: 교체할 model 값
    func updatePremiumTier(documentID: String, originalPersonRequest request: PremiumModel, completionHandler: @escaping ((_ item: PremiumModel?) -> ())) {
        print("updatePremiumTier")
        do {
            try premiumTierRef.document(documentID).setData(from: request) { err in
                if let err = err {
                    print("Firestore>> Error updating document: \(err)")
                    completionHandler(nil)
                    return
                }
                
                print("Firestore>> Document updating with ID: \(documentID)")
                completionHandler(request)
            }
        } catch {
            print("Firestore>> Error from updatePost-setData: ", error)
            completionHandler(nil)
        }
    }

}
