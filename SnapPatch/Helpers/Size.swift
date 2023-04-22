//
//  Size.swift
//  SnapPatch
//

import UIKit


extension CGSize {
    
    var toSquareSize: CGSize {
        
        if width == height {
            return self
        }
        
        if width < height {
            return .init(width: width, height: width)
        }
        
        return .init(width: height, height: height)
    }
    
}
