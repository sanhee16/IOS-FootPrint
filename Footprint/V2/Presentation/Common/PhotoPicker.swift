//
//  PhotoPicker.swift
//  Footprint
//
//  Created by sandy on 8/24/24.
//

import SwiftUI
import PhotosUI

class PhotoSelectorViewModel: ObservableObject {
    @Published var images = [UIImage]()
    @Published var selectedPhotos = [PhotosPickerItem]()
    
    @MainActor
    func convertDataToImage() {
        // reset the images array before adding more/new photos
        images.removeAll()
        
        if !selectedPhotos.isEmpty {
            for eachItem in selectedPhotos {
                Task {
                    if let imageData = try? await eachItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: imageData) {
                            images.append(image)
                        }
                    }
                }
            }
        }
        
        // uncheck the images in the system photo picker
        selectedPhotos.removeAll()
    }
}

struct PhotoSelectorView: View {
    @StateObject var vm = PhotoSelectorViewModel()
    let maxPhotosToSelect = 10
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(300))]) {
                    ForEach(0..<vm.images.count, id: \.self) { index in
                        Image(uiImage: vm.images[index])
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            PhotosPicker(
                selection: $vm.selectedPhotos, // holds the selected photos from the picker
                maxSelectionCount: maxPhotosToSelect, // sets the max number of photos the user can select
                selectionBehavior: .ordered, // ensures we get the photos in the same order that the user selected them
                matching: .images // filter the photos library to only show images
            ) {
                // this label changes the text of photo to match either the plural or singular case based on the value in maxPhotosToSelect
                Label("Select up to ^[\(maxPhotosToSelect) photo](inflect: true)", systemImage: "photo")
            }
        }
        .padding()
        .onChange(of: vm.selectedPhotos, perform: { value in
            vm.convertDataToImage()
        })
    }
}

//#Preview {
//    PhotoSelectorView()
//}
