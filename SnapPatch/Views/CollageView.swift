//
//  CollageView.swift
//  SnapPatch
//

import SwiftUI

struct CollageView: View {
    
    var size: CGSize
    var type: CollageType
    
    var dividerCount: Int {
        type.content.count - 1
    }
    
    var denom: CGFloat {
        type.content.reduce(0) { $0 + $1.length }
    }
    
    @State var factors: [CGFloat]
    
    init(size: CGSize, type: CollageType) {
        self.size = size
        self.type = type
        
        _factors = State(initialValue: type.factorsArray)
    }
    
    var body: some View {
        
        switch type {
            
            case .row(let array, _):
                VStack(spacing: 0) {
                    
                    ForEach(Array(array.enumerated()), id: \.element) { typ in
                        let index = typ.offset
                        let num = index == 0 ? factors[0] : factors[index] - factors[index - 1]
                        let fraction = CGFloat(num) / CGFloat(denom)
                        let size = type.isRow ?
                                    CGSize.init(width: size.width, height: size.height * fraction) :
                                    CGSize.init(width: size.width * fraction, height: size.height)
                        
                        CollageView(size: size, type: typ.element)
                    }
                    
                }.frame(width: size.width, height: size.height)
                .overlay {
                    VStack(spacing: 0) {
                        ForEach(0..<(factors.count - 1)) { index in
                            Rectangle()
                                .frame(height: 4)
                                .offset(y: -size.height / 2)
                                .offset(y: size.height * (factors[index] / denom) )
                                .gesture(
                                    DragGesture(minimumDistance: 2, coordinateSpace: .local)
                                        .onChanged { value in
                                            let pt = value.location.y + (size.height / 2)
                                            let res = pt / (size.height/denom)
                                            factors[index] = res
                                        }
                                )
                        }
                    }.frame(width: size.width, height: size.height, alignment: .leading)
                }
            
            case .column(let array, _):
                HStack(spacing: 0) {
                    
                    ForEach(Array(array.enumerated()), id: \.element) { typ in
                        let index = typ.offset
                        let num = index == 0 ? factors[0] : factors[index] - factors[index - 1]
                        let fraction = CGFloat(num) / CGFloat(denom)
                        let size = type.isRow ?
                                    CGSize.init(width: size.width, height: size.height * fraction) :
                                    CGSize.init(width: size.width * fraction, height: size.height)
                        
                        CollageView(size: size, type: typ.element)
                    }
                    
                }.frame(width: size.width, height: size.height)
                .overlay {
                    HStack(spacing: 0) {
                        ForEach(0..<(factors.count - 1)) { index in
                            Rectangle()
                                .frame(width: 4)
                                .offset(x: -size.width / 2)
                                .offset(x: size.width * (factors[index] / denom) )
                                .gesture(
                                    DragGesture(minimumDistance: 2, coordinateSpace: .local)
                                        .onChanged { value in
                                            let pt = value.location.x + (size.width / 2)
                                            let res = pt / (size.width/denom)
                                            factors[index] = res
                                        }
                                )
                        }
                    }.frame(width: size.width, height: size.height)
                }
            
            case .data(let uIColor, _):
                VStack { }
                .frame(width: size.width, height: size.height)
                .modifier(BgModifier(color: .init(uiColor: uIColor), fill: true))
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
                    type: .column([.data(.red, 1), .data(.green, 1)], 1)
                )
                Spacer()
            }
        }.padding().padding()
    }
}

