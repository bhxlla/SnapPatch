//
//  CollageMainView.swift
//  SnapPatch

import SwiftUI

struct CollageMainView: View {
    
    let initSize: CGFloat = 360
    
    let type: CollageType = .column([.data(.systemTeal, 1), .data(.systemPink, 2)], 1)
    
    var body: some View {
        GeometryReader { proxy in
            CollageView(size: proxy.size, type: type)
        }
        .frame(width: initSize, height: initSize)
        .cornerRadius(12)
    }
}

struct CollageMainView_Previews: PreviewProvider {
    static var previews: some View {
        CollageMainView()
    }
}
