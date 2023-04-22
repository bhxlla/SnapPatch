//
//  CollageMainView.swift
//  SnapPatch

import SwiftUI

struct CollageMainView: View {
    
    let initSize: CGFloat = 360
    
    let type: CollageType = .column([.data(.systemTeal, 1), .data(.systemPink, 2)], 1)
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                CollageView(size: proxy.size.toSquareSize, type: type)
                    .cornerRadius(12)
                Spacer()
            }
        }
        .padding()
        .padding()        
    }
}

struct CollageMainView_Previews: PreviewProvider {
    static var previews: some View {
        CollageMainView()
    }
}
