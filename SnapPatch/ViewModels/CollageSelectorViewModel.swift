//
//  CollageSelectorViewModel.swift
//  SnapPatch


import SwiftUI

class CollageSelectorViewModel: ObservableObject {
    
    let collages: [CollageType] = CollageType.collages
    
    @Published var selectedCollage: CollageType? = nil
    @Published var showCollageOptions = false
    
    init() {
        self.selectedCollage = collages[0]
    }
    
    func toggleSelector() {
        withAnimation {
            showCollageOptions.toggle()
        }
    }
    
    func select(collage: CollageType) {
        selectedCollage = nil
        toggleSelector()
        DispatchQueue.main.async {
            self.selectedCollage = collage
        }
    }
    
    func addImageToSelectedCollageBlock(_ image: UIImage) {
        showCollageOptions = .home
        defer { selectedCollageBlock = nil }
        guard let id = selectedCollageBlock else { return }
        
        func modifyNestedCollageType(_ collageType: inout CollageType) {
            switch collageType {
            case .row(var collages, let size):
                for i in 0..<collages.type.count {
                    modifyNestedCollageType(&collages.type[i])
                }
                collageType = .row(collages, size)
            case .column(var collages, let size):
                for i in 0..<collages.type.count {
                    modifyNestedCollageType(&collages.type[i])
                }
                collageType = .column(collages, size)
            case .data(var container, let size):
                if container.id == id {
                    container.type = .image(image)
                    collageType = .data(container, size)
                }
            }
        }
        
        modifyNestedCollageType(&selectedCollage!)
    }
    
    func addImageToSelectedCollage(_ asset: Asset) {
        ImagePicker.getFullImage(for: asset, addImageToSelectedCollageBlock)
        
    }
}
