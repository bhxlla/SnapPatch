//
//  CollageMainView.swift
//  SnapPatch

import SwiftUI

struct CollageMainView: View {
    
    @StateObject var collageSelector: CollageSelectorViewModel = .init()    
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                if collageSelector.selectedCollage != nil {
                    CollageView(size: proxy.size.toSquareSize, type: collageSelector.selectedCollage!)
                    .cornerRadius(12)
                }
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
