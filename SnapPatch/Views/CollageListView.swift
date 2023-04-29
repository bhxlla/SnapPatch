//
//  CollageListView.swift
//  SnapPatch

import SwiftUI

struct CollageListView: View {
    
    @EnvironmentObject var selector: CollageSelectorViewModel
    
    var body: some View {
        ScrollView.init(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(selector.collages) { collage in
                    Button {
                        selector.select(collage: collage)
                    } label: {
                        CollageView(size: .init(width: 108, height: 108), type: collage, isMini: true)
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                            .allowsHitTesting(false)
                    }

                }
                
            }.padding(.horizontal)
        }
    }
}

struct CollageListView_Previews: PreviewProvider {
    static var previews: some View {
        CollageListView()
    }
}
