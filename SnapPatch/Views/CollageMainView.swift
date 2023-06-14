//
//  CollageMainView.swift
//  SnapPatch

import SwiftUI

struct CollageMainView: View {
    
    @StateObject var collageSelector: CollageSelectorViewModel = .init()    
    @StateObject var imagesSelector: ImageSelectorViewModel = .init()
    
    @State var selectedRatio: CollageRatios = .oneone
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                Spacer()
                if collageSelector.selectedCollage != nil {
                    CollageView(
                        size: proxy.size.minusHeight(100 + 100).sizeWith(ratio: selectedRatio),
                        type: collageSelector.selectedCollage!
                    )
                    .environmentObject(collageSelector)
                    .cornerRadius(12)
                    .transition(.opacity)
                }
                Spacer()
                if collageSelector.showCollageOptions != .home {
                    Rectangle()
                        .fill(.clear)
//                        .fill(.red)
                        .frame(height: 100 + 100)
                        .transition(.move(edge: .bottom))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .padding()
        .overlay(alignment: .bottom) {
            if collageSelector.showCollageOptions == .collages {
                VStack {
                    CollageRatioPicker(selected: $selectedRatio)
                    CollageListView()
                        .environmentObject(collageSelector)
                }
                .frame(height: 100 + 100)
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                .transition(.move(edge: .bottom).combined(with: .opacity))

            } else if collageSelector.showCollageOptions == .images {
                ImagesSelector()
                    .environmentObject(imagesSelector)
                    .environmentObject(collageSelector)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                HStack(spacing: 24) {
                    Spacer()
                    layoutsBtn
                    Spacer()
                }
                .padding(.vertical)
                .background {
                    Rectangle()
                        .fill(Color(uiColor: .clear))
                        .background(.thinMaterial)
                        .cornerRadius(24)
                }.padding(.horizontal).padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

extension CollageMainView {
    
    var layoutsBtn: some View {
        Button {
            collageSelector.changeView(to: .collages)
        } label: {
            Image("layout")
                .resizable()
                .tint(.white.opacity(3/4))
                .frame(width: 42, height: 42)
        }
    }
    
}

struct CollageMainView_Previews: PreviewProvider {
    static var previews: some View {
        CollageMainView()
            .preferredColorScheme(.dark)
    }
}
