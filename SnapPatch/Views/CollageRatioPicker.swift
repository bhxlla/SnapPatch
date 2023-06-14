//
//  CollageRatioPicker.swift
//  SnapPatch
//


import SwiftUI

struct CollageRatioPicker: View {
    
    let allRatios = CollageRatios.allCases
    
    @Binding var selected: CollageRatios
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                
                ForEach(allRatios, id: \.self) { ratio in
                    
                    let size: CGSize = .init(width: 50, height: 50).sizeWith(ratio: ratio)
                    
                    Button {
                        withAnimation() {
                            selected = ratio
                        }
                    } label: {
                        VStack {
                            Spacer(minLength: 0)
                            Rectangle()
                                .stroke()
                                .frame(width: size.width, height: size.height)
                                .padding(.all, 4)
                            
                            Spacer(minLength: 0)
                            
                            Text(ratio.label)
                                .font(.monospaced(.caption2)())
                        }
                    }
                    .tint(.secondary)
                    .padding(.vertical, 2).padding(.bottom, 2)

                    
                }
                
            }.padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: 72)
    }
}

struct CollageRatioPicker_Previews: PreviewProvider {
    static var previews: some View {
        CollageRatioPicker(selected: .constant(.fiveThree))
            .preferredColorScheme(.dark)
            .background(.gray.opacity(1/5))
    }
}
