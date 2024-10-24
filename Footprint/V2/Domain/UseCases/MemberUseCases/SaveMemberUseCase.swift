//
//  SaveMemberUseCase.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation
import SwiftUI

class SaveMemberUseCase {
    let memberRepository: MemberRepository
    
    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    func execute(_ id: String? = UUID().uuidString, name: String, image: UIImage? = nil, intro: String) {
        var imageName: String = ""
        if let image = image {
            let currentTimeStamp = Int(Date().timeIntervalSince1970)
            imageName = "\(currentTimeStamp)_people_with"
            _ = ImageManager.shared.saveImage(image: image, imageName: imageName)
        } else {
            imageName = ""
        }
        self.memberRepository.addMember(id, name: name, image: imageName, intro: intro)
    }
}
