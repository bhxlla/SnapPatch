//
//  ImageSelectorViewModel.swift
//  SnapPatch

import SwiftUI

class ImageSelectorViewModel: ObservableObject {
    
    @Published var selectedImage: UIImage? = nil
    @Published var assets: [Asset] = []
    
    let imageSelectorService: ImagePicker
    
    init() {
        imageSelectorService = .init()
        bindServices()
    }
    
    func bindServices() {
        imageSelectorService.$fetchedPhotos
            .assign(to: &$assets)
    }
    
}

