//
//  GalleryViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//
import Foundation
import Combine
import Kingfisher
import Photos
import SwiftUI

class GalleryViewModel: BaseViewModel {
    private var images: PHFetchResult<PHAsset>? = nil
    private let PAGE_SIZE = 30
    var items: [GalleryItem] = []
    var hasNextPage: Bool = true
    var isFirstLoading = false
    var isLoading: Bool = false
    var onClickItem: ((GalleryItem)->())?
    @Published var item: GalleryItem? = nil
    
    init(_ coordinator: AppCoordinator, onClickItem: ((GalleryItem)->())?) {
        self.onClickItem = onClickItem
        super.init(coordinator)
        loadAllImages()
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func loadAllImages(_ done: (() -> Void)? = nil) {
        let options = PHFetchOptions()
        
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allImages = PHAsset.fetchAssets(with: .image, options: options)
        if allImages.count <= 0 { // 사진 없음
            self.images = nil
            isLoading = false
            hasNextPage = false
            isFirstLoading = false
            items.removeAll()
            self.objectWillChange.send()
            return
        }
        self.images = allImages
        isLoading = false
        hasNextPage = true
        isFirstLoading = true
        items.removeAll()
        self.objectWillChange.send()
        loadNextImage(done)
    }
    
    func loadNextImage(_ done: (() -> Void)? = nil) {
        guard !isLoading, hasNextPage, let images = self.images else {
            done?()
            return
        }
        
        let startAt = self.items.count
        var endAt = startAt + self.PAGE_SIZE
        
        if endAt > images.count {
            self.hasNextPage = false
            endAt = images.count
        }
        if startAt == endAt {
            self.hasNextPage = false
            self.objectWillChange.send()
            done?()
            return
        }
        
        let indexSet = IndexSet(startAt..<endAt)
        DispatchQueue.global(qos: .background).async {
            images.enumerateObjects(at: indexSet, options: []) { [weak self] (asset, index, stop) in
                guard let self = self else { return }
                let imageSize = UIScreen.main.bounds.size.width
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                options.resizeMode = .fast
                options.isNetworkAccessAllowed = true
                
                PHImageManager.default().requestImage(
                    for: asset,
                    targetSize: CGSize(width: imageSize, height: imageSize),
                    contentMode: .aspectFill,
                    options: options
                ) {(image, info) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.items.append((image, asset))
                    }
                }
                if self.items.count == endAt {
                    self.isLoading = false
                    
                    if self.isFirstLoading {
                        self.isFirstLoading = false
                    }
                    DispatchQueue.main.async {
                        done?()
                        self.objectWillChange.send()
                    }
                }
            }
        }
    }
    
    func onSelectImage() {
        self.coordinator?.dismiss {[weak self] in
            guard let self = self, let item = self.item else { return }
            self.onClickItem?(item)
        }
    }
    
    func onClickItem(_ item: GalleryItem) {
        self.item = item
    }
    
    private func photoPermissionCheck() {
        let photoAuthStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthStatus {
        case .notDetermined:
            print("권한 승인을 아직 하지 않음")
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .denied:
                    print("거부됨")
                    break
                case .authorized:
                    print("승인됨")
                    break
                default:
                    break
                }
            }
        case .restricted:
            print("권한을 부여할 수 없음")
            break
        case .denied:
            print("거부됨")
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .denied:
                    print("거부됨")
                    break
                case .authorized:
                    print("승인됨")
                    break
                default:
                    break
                }
            }
            break
        case .authorized:
            print("승인됨")
            break
        case .limited:
            print("limited")
            break
        @unknown default:
            print("unknown default")
            break
        }
    }
}
