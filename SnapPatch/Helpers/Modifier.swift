//
//  Modifier.swift
//  SnapPatch
//

import SwiftUI

struct BgModifier: ViewModifier {
    
    var color: Color
    var fill: Bool = false
    
    func body(content: Content) -> some View {
        if fill {
            content
                .background {
                    Rectangle().fill(color)
                }
        } else {
            content
                .background {
                    Rectangle().stroke().fill(color)
                }
        }
    }
    
}
