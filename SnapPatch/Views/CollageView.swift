//
//  CollageView.swift
//  SnapPatch
//

import SwiftUI

struct CollageView: View {
    
    var size: CGSize
    var type: CollageType
    
    var body: some View {
        Rectangle()
            .fill(.green)
            .frame(width: size.width, height: size.height)
    }
}

struct CollageView_Previews: PreviewProvider {
    static var previews: some View {
        CollageView(
            size: .init(width: 240, height: 240),
            type: .column([.data(.red, 1), .data(.green, 1)], 1)
        )
    }
}

