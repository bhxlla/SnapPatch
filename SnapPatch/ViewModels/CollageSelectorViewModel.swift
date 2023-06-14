//
//  CollageSelectorViewModel.swift
//  SnapPatch


import SwiftUI

enum HomeState {
    case home, collages, images
}

class CollageSelectorViewModel: ObservableObject {
    
    let collages: [CollageType] = CollageType.collages
    
    @Published var selectedCollage: CollageType? = nil
    @Published var showCollageOptions: HomeState = .home
    
    var selectedCollageBlock: String?
    
    var replacementIDs: (Container?, Container?) = (nil, nil)
    
    init() {
        self.selectedCollage = collages[0]
    }
    
    func changeView(to state: HomeState = .home) {
        withAnimation {
            showCollageOptions = state
        }
    }
    
    func select(collage: CollageType) {
        selectedCollage = nil
        changeView()
        DispatchQueue.main.async {
            self.selectedCollage = collage
        }
    }
    
    func selectBlock(with id: String) {
        selectedCollageBlock = id
        withAnimation {
            showCollageOptions = .images
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
    
    func resolveFactorsArray(_ array: [CGFloat]) -> [CGFloat] {
        var arr: [CGFloat] = []
        
        arr.append(array[0])
        
        for index in (1..<array.count) {
            let result = (array[index] - array[index - 1])// / array[lastIndex]
            arr.append(result)
        }
        
        print(arr)
        return arr
    }
    
    func iterateOverSelectedCollage(for type: CollageType, factorsArray: [CGFloat]) {
        
        let resolvedFactors = resolveFactorsArray(factorsArray)
        
        func modifyNestedCollageType(_ collageType: inout CollageType, _ factor: CGFloat? = nil) {

            switch collageType {
            
            case .row(var collages, let size):
                for i in 0..<collages.type.count {
                    var element = collages.type[i]
                    if type.id == collageType.id {
                        modifyNestedCollageType(&element, resolvedFactors[i])
                    } else {
                        modifyNestedCollageType(&element)
                    }
                    collages.type[i] = element
                }
                print("factor: ", factor ?? size)
                collageType = .row(collages, factor ?? size)
            
            case .column(var collages, let size):
                for i in 0..<collages.type.count {
                    var element = collages.type[i]
                    if type.id == collageType.id {
                        modifyNestedCollageType(&element, resolvedFactors[i])
                    } else {
                        modifyNestedCollageType(&element)
                    }
                    collages.type[i] = element
                }
                print("factor: ", factor ?? size)
                collageType = .column(collages, factor ?? size)
            
            case .data(let container, let size):
                print("factor: ", factor ?? size)
                collageType = .data(container, factor ?? size)
                
            }
        }
        
        modifyNestedCollageType(&selectedCollage!)
    }
    
    
    func selectForReplaceMent(id: Container){
        if replacementIDs == (nil, nil) {
            replacementIDs = (id, nil)
            return
        }
        if replacementIDs.0 != nil && replacementIDs.1 == nil {
            replacementIDs.1 = id
            replaceIds(c1: replacementIDs.0!, c2: replacementIDs.1!)
            return
        }
    }
    
    func replaceIds(c1: Container, c2: Container) {
        func modifyCollageType(_ collage: inout CollageType) {
            
            switch collage {
            case .row(var viewContainer, let factor):
                for i in 0..<viewContainer.type.count {
                    var element = viewContainer.type[i]
                    modifyCollageType(&element)
                    viewContainer.type[i] = element
                }
                collage = .row(viewContainer, factor)
            
            case .column(var viewContainer, let factor):
                for i in 0..<viewContainer.type.count {
                    var element = viewContainer.type[i]
                    modifyCollageType(&element)
                    viewContainer.type[i] = element
                }
                collage = .column(viewContainer, factor)
            
            case .data(let container, let factor):
                switch container.type {
                    case .empty(_): ()
                    case .image(_):
                    if container.id == c1.id {
                        collage = .data(c2, factor)
                    }
                    if container.id == c2.id {
                        collage = .data(c1, factor)
                    }
                }
                
            }
            
        }
        modifyCollageType(&selectedCollage!)
        replacementIDs = (nil, nil)
    }
    
}
