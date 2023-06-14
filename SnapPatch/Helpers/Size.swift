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
    
    func sizeWith(ratio: CollageRatios) -> CGSize {
        
        let currentRatio = width / height
        let desiredRatio = ratio.value

        var newWidth: CGFloat
        var newHeight: CGFloat

        if currentRatio > desiredRatio {
            newWidth = height * desiredRatio
            newHeight = height
        } else {
            newWidth = width
            newHeight = width / desiredRatio
        }

        return CGSize(width: newWidth, height: newHeight)
    }
    
    func minusWidth(_ value: CGFloat) -> CGSize {
        .init(width: width - value, height: height)
    }
    
    func minusHeight(_ value: CGFloat) -> CGSize {
        .init(width: width, height: height - value)
    }
    
}
