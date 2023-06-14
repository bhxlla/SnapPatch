//
//  CollageView.swift
//  SnapPatch
//

import SwiftUI

struct CollageView: View {
    
    var size: CGSize
    var type: CollageType
    
    var isMini = false
    
    var dividerCount: Int {
        type.content.count - 1
    }
    
    var denom: CGFloat {
        type.content.reduce(0) { $0 + $1.length }
    }
    
    @State var factors: [CGFloat]
    @EnvironmentObject var collageSelector: CollageSelectorViewModel
    
    init(size: CGSize, type: CollageType, isMini: Bool = false) {
        self.size = size
        self.type = type
        self.isMini = isMini
        _factors = State(initialValue: type.factorsArray)
    }
 
    func getSize(with fraction: CGFloat) -> CGSize {
        type.isRow ?
            CGSize.init(width: size.width, height: size.height * fraction) :
            CGSize.init(width: size.width * fraction, height: size.height)
    }
    
    var body: some View {
        
        switch type {
            
            case .row(let array, _):
                VStack(spacing: 0) {
                    
                    ForEach(Array(array.type.enumerated()), id: \.element) { typ in
                        let index = typ.offset
                        let num = index == 0 ? factors[0] : factors[index] - factors[index - 1]
                        let fraction = CGFloat(num) / CGFloat(denom)
                        let size = getSize(with: fraction)
                        
                        CollageView(size: size, type: typ.element, isMini: isMini)
                    }
                    
                }.frame(width: size.width, height: size.height)
                .overlay {
                    ZStack {
                        ForEach(0..<(factors.count - 1)) { index in
                            Rectangle()
                                .fill(.secondary.opacity(1/4))
                                .frame(height: isMini ? 1 : 4)
                                .offset(y: -size.height / 2)
                                .offset(y: size.height * (factors[index] / denom) )
                                .gesture(
                                    DragGesture(minimumDistance: 2, coordinateSpace: .local)
                                        .onChanged { value in
                                            let pt = value.location.y + (size.height / 2) - 2
                                            let res = pt / (size.height/denom)
                                            factors[index] = res
                                        }
                                        .onEnded { _ in
                                            collageSelector.iterateOverSelectedCollage(for: type, factorsArray: factors)
                                        }
                                )
                        }
                    }.frame(width: size.width, height: size.height, alignment: .leading)
                }
            
            case .column(let array, _):
                HStack(spacing: 0) {
                    
                    ForEach(Array(array.type.enumerated()), id: \.element) { typ in
                        let index = typ.offset
                        let num = index == 0 ? factors[0] : factors[index] - factors[index - 1]
                        let fraction = CGFloat(num) / CGFloat(denom)
                        let size = getSize(with: fraction)
                        
                        CollageView(size: size, type: typ.element, isMini: isMini)
                    }
                    
                }.frame(width: size.width, height: size.height)
                .overlay {
                    ZStack {
                        ForEach(0..<(factors.count - 1)) { index in
                            Rectangle()
                                .fill(.secondary.opacity(1/4))
                                .frame(width: isMini ? 1 : 4)
                                .offset(x: -size.width / 2)
                                .offset(x: size.width * (factors[index] / denom) )
                                .gesture(
                                    DragGesture(minimumDistance: 2, coordinateSpace: .local)
                                        .onChanged { value in
                                            let pt = value.location.x - 2 + (size.width / 2)
                                            let res = pt / (size.width/denom)
                                            factors[index] = res
                                        }
                                        .onEnded { _ in
                                            collageSelector.iterateOverSelectedCollage(for: type, factorsArray: factors)
                                        }
                                )
                        }
                    }.frame(width: size.width, height: size.height)
                }
            
            case .data(let container, _):
                ContainerView(container)
        }
        
    }
    
    @ViewBuilder
    func ContainerView(_ container: Container) -> some View {
        
        switch container.type {
        
            case .empty(let uIColor):
                VStack {
                    if !isMini {
                        Button {
                            collageSelector.selectBlock(with: container.id)
                        } label: {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tint(.white.opacity(1/3))
                                .frame(width: 32, height: 32)
                        }
                    }
                }
                .frame(width: size.width, height: size.height)
                .modifier(BgModifier(color: .init(uiColor: uIColor).opacity(1/2), fill: true))

            
            case .image(let uIImage):
                CollageImageView.init(image: uIImage, size: size)
                .onTapGesture {
                    withAnimation {
                        collageSelector.selectForReplaceMent(id: container)
                    }
                }
        }
        
    }
}

struct CollageView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            let size = proxy.size.toSquareSize
            VStack {
                Spacer()
                CollageView(
                    size: .init(width: size.width, height: size.height),
                    type: .column(.init(type: [
                        .data(.init(type: .empty(.red)), 1),
                        .data(.init(type: .empty(.blue)), 1),
                    ]), 1)
                )
                Spacer()
            }
        }.padding().padding()
    }
}

