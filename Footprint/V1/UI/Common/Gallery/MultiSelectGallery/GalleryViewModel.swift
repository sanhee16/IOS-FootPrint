//
//  MultiSelectGalleryViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//
import Foundation
import Combine
import Kingfisher
import Photos
import SwiftUI
import SDSwiftUIPack

enum GalleryType {
    case single
    case multi
}

class GalleryViewModel: BaseViewModelV1 {
    private var images: PHFetchResult<PHAsset>? = nil
    private let PAGE_SIZE = 50
    @Published var items: [GalleryItem] = []
    @Published var hasNextPage: Bool = true
//    @Published var isFirstLoading = false
    var isLoading: Bool = false
    var onClickItem: (([GalleryItem])->())?
//    @Published var item: GalleryItem? = nil
    @Published var selectedImages: [GalleryItem] = []
    @Published var selectedImage: GalleryItem? = nil
    @Published var type: GalleryType
    @Published var isAvailableSelect: Bool = false

    init(_ coordinator: AppCoordinatorV1, type: GalleryType, onClickItem: (([GalleryItem])->())?) {
        self.onClickItem = onClickItem
        self.type = type
        super.init(coordinator)
        loadAllImages()
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    // https://rhammer.tistory.com/229
    func loadAllImages(_ done: (() -> Void)? = nil) {
        if self.isLoading {
            done?()
            return
        }
        self.isLoading = true
        let options = PHFetchOptions()
        
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        // 모든 사진의 정보(PHFetchResult<PHAsset>)를 불러온다
        let allImages = PHAsset.fetchAssets(with: .image, options: options)
        if allImages.count <= 0 { // 사진 없음
            self.images = nil
            isLoading = false
            hasNextPage = false
            items.removeAll()
            return
        }
        self.images = allImages
        items.removeAll()
        isLoading = false
        hasNextPage = true
        loadNextImage(done)
    }
    
    func loadNextImage(_ done: (() -> Void)? = nil) {
        print("loadNextImage: \(isLoading)")
        guard !isLoading, hasNextPage, let images = self.images else {
            done?()
            return
        }
        self.isLoading = true
        
        let startAt = self.items.count
        var endAt = startAt + self.PAGE_SIZE
        
        if endAt > images.count {
            self.hasNextPage = false
            endAt = images.count
        }
        if startAt == endAt {
            self.hasNextPage = false
            done?()
            return
        }
        
        print("startAt~endAt: \(startAt)~\(endAt)")
        let indexSet = IndexSet(startAt..<endAt)
        
        DispatchQueue.global(qos: .background).async {
            images.enumerateObjects(at: indexSet, options: []) { [weak self] (asset, index, stop) in
                guard let self = self else { return }
                let imageSize = UIScreen.main.bounds.size.width / 3
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
                        self.items.append(GalleryItem(image: image, asset: asset, isSelected: false))
                        print("append item: \(self.items.count)")
                        if self.items.count == endAt {
                            self.isLoading = false
                            DispatchQueue.main.async {
                                done?()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func onSelectImage() {
        switch self.type {
        case .multi:
            if self.selectedImages.isEmpty {
                return
            }
            self.coordinator?.dismiss {[weak self] in
                guard let self = self else { return }
                self.onClickItem?(self.selectedImages)
            }
        case .single:
            guard let selectedImage = self.selectedImage else { return }
            self.coordinator?.dismiss {[weak self] in
                guard let self = self else { return }
                self.onClickItem?([selectedImage])
            }
        }
    }
    
    func onClickItem(_ item: GalleryItem) {
        switch self.type {
        case .single:
            if let i = self.items.firstIndex(of: item) {
                if let selectedImage = self.selectedImage {
                    self.selectedImage = nil
                    if selectedImage == item {
                        self.items[i].isSelected = false
                        self.isAvailableSelect = false
                        break
                    } else {
                        if let j = self.items.firstIndex(of: selectedImage) {
                            self.items[j].isSelected = false
                        }
                    }
                }
                self.items[i].isSelected = true
                self.selectedImage = item
                self.isAvailableSelect = true
            }
        case .multi:
            if let i = self.items.firstIndex(of: item) {
                if let idx = self.selectedImages.firstIndex(of: item) {
                    self.items[i].isSelected = false
                    self.selectedImages.remove(at: idx)
                } else {
                    self.items[i].isSelected = true
                    self.selectedImages.append(item)
                }
                self.isAvailableSelect = !self.selectedImages.isEmpty
            }
        }
        
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
