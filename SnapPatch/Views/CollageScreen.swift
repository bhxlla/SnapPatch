//
//  CollageScreen.swift
//  SnapPatch


import SwiftUI

struct CollageScreen: View {
    var body: some View {
        ZStack {
            Color.init(uiColor: .systemGray6)
                .ignoresSafeArea()
            
            CollageMainView()
        }
    }
}

struct CollageScreen_Previews: PreviewProvider {
    static var previews: some View {
        CollageScreen()
    }
}
