//
//  CollageMainView.swift
//  SnapPatch

import SwiftUI

struct CollageMainView: View {
    
    let initSize: CGFloat = 360
    
    let type: CollageType = .row(
        [
            .data(.systemTeal, 1),
            .column([
                .data(.systemPink, 1),
                .data(.systemGreen, 1)
            ], 1)
        ], 1
    )
    
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
            .preferredColorScheme(.dark)
    }
}
