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
                        .transition(.opacity)
                }
                Spacer()
                if collageSelector.showCollageOptions {
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 108)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .padding()
        .padding()
        .overlay(alignment: .bottom) {
            if collageSelector.showCollageOptions {
                CollageListView()
                    .environmentObject(collageSelector)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                layoutsBtn
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

extension CollageMainView {
    
    var layoutsBtn: some View {
        Button {
            collageSelector.toggleSelector()
        } label: {
            Text("Layouts")
                .foregroundColor(.primary)
                .font(.monospaced(.title3)())
                .padding().padding(.horizontal)
                .background {
                    Capsule(style: .circular)
                        .fill(Color(uiColor: .systemIndigo))
                }
        }
    }    
}

struct CollageMainView_Previews: PreviewProvider {
    static var previews: some View {
        CollageMainView()
            .preferredColorScheme(.dark)
    }
}
