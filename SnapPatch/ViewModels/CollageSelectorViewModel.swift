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
    
}
