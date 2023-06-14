//
//  ImagesSelector.swift
//  SnapPatch

import SwiftUI

struct ImagesSelector: View {
    
    @EnvironmentObject var selector: ImageSelectorViewModel
    @EnvironmentObject var collageSelector: CollageSelectorViewModel
    
    var body: some View {
        ScrollView.init(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(selector.assets, id: \.id) { asset in
                    Button {
                        collageSelector.addImageToSelectedCollage(asset)
                    } label: {
                        Image(uiImage: asset.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 108)
                            .cornerRadius(9)
                            .padding(.horizontal, 4)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ImagesSelector_Previews: PreviewProvider {
    static var previews: some View {
        ImagesSelector()
    }
}
