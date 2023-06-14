//
//  CollageImageView.swift
//  SnapPatch
//

import SwiftUI

struct CollageImageView: View {
    
    let image: UIImage
    let size: CGSize
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .cornerRadius(0)
                .allowsHitTesting(false)
        }
            .frame(width: size.width, height: size.height)
            .contentShape(Rectangle())
    }
}

struct CollageImageView_Previews: PreviewProvider {
    static var previews: some View {
        CollageImageView(image: .init(named: "june")!, size: .init(width: 200, height: 200))
    }
}
