//
//  CollageType.swift
//  SnapPatch


import UIKit

enum CollageType: Hashable, Identifiable {
    
    var id: Self { self }
    
    case row([CollageType], CGFloat)
    case column([CollageType], CGFloat)
    case data(UIColor, CGFloat)
    
}
