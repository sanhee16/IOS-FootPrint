//
//  UpdateMemberUseCase.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import Foundation
import UIKit

class UpdateMemberUseCase {
    let memberRepository: MemberRepository
    
    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    func execute(_ id: String, idx: Int, name: String, image: UIImage? = nil, intro: String) {
        var imageName: String = ""
        if let image = image {
            imageName = "\(UUID().uuidString)_member"
            _ = ImageManager.shared.saveImage(image: image, imageName: imageName)
        } else {
            imageName = ""
        }

        self.memberRepository.updateMember(id, idx: idx, name: name, image: imageName, intro: intro)
    }
}


