//
//  CollageType.swift
//  SnapPatch


import UIKit

enum CollageType: Hashable, Identifiable {
    
    var id: Self { self }
    
    case row([CollageType], CGFloat)
    case column([CollageType], CGFloat)
    case data(UIColor, CGFloat)
    
    enum Base: String {
        case row, column, data
    }
    
}

extension CollageType {
    
    var length: CGFloat {
        switch self {
        case .row(_, let i):
            return i;
        case .column(_, let i):
            return i;
        case .data(_, let i):
            return i;
        }
    }
    
    var content: [CollageType] {
        switch self {
        case .row(let array, _):
            return array
        case .column(let array, _):
            return array
        case .data(_, _):
            return []
        }
    }
    
    var isRow: Bool {
        switch self {
        case .row(_, _):
            return true;
        default:
            return false;
        }
    }
    
    var factorsArray: [CGFloat] {
        let mapped = self.content.map { $0.length }
        let resut: [CGFloat] = mapped.enumerated().map { (offset, element) in
            let result = (0...offset).reduce(0) { partialResult, index in partialResult + mapped[index] }
            return result
        }
        return resut
    }
 
    func viewTypeToDict(_ viewType: CollageType) -> [String: Any] {
        switch viewType {
        case .row(let subviews, let d):
            let subviewDicts = subviews.map { viewTypeToDict($0) }
            return ["type": "row", "subviews": subviewDicts, "d": d]
            
        case .column(let subviews, let d):
            let subviewDicts = subviews.map { viewTypeToDict($0) }
            return ["type": "column", "subviews": subviewDicts, "d": d]
            
        case .data(_, let d):
            return ["type": "data", "d": d]
        }
    }
    
    static func dictToViewType(_ dict: [String: Any]) -> CollageType? {
        guard let typeString = dict["type"] as? String,
              let base = CollageType.Base(rawValue: typeString) else {
            return nil
        }
        
        switch base {
        case .row:
            guard let subviewsDicts = dict["subviews"] as? [[String: Any]], let spacing = dict["d"] as? CGFloat else { return nil }
            let subviews = subviewsDicts.compactMap { dictToViewType($0) }
            return .row(subviews, spacing)
            
        case .column:
            guard let subviewsDicts = dict["subviews"] as? [[String: Any]], let spacing = dict["d"] as? CGFloat else { return nil }
            let subviews = subviewsDicts.compactMap { dictToViewType($0) }
            return .column(subviews, spacing)
            
        case .data:
            guard let size = dict["d"] as? CGFloat else { return nil }
            return .data(.clear, size)
        }
    }
    
    var stringy: String {
        switch self {
        case .row(_, _): return "Row"
        case .column(_, _): return "Column"
        case .data(_, _): return "Data"
        }
    }
    
}


extension CollageType {
    
    static let collages: [CollageType] = [
    
        .column([.data(.systemIndigo, 1), .data(.systemGreen, 1)], 1),
        .row([.data(.systemPink, 1), .data(.systemTeal, 1)], 1),
    
        .row([
            .column([ .data(.systemOrange, 1), .data(.systemGray2, 1) ], 1),
            .data(.systemBrown, 1)
        ], 1),
    
        .row([
            .data(.systemYellow, 1),
            .column([ .data(.systemGreen, 1), .data(.systemIndigo, 1) ], 1),
        ], 1),
    
        .column([
            .row([
                .data(.systemRed, 1),
                .data(.systemTeal, 1)
            ], 1),
            .data(.systemGreen, 1)
        ], 1),
    
        .column([
            .data(.systemPurple, 1),
            .row([
                .data(.systemMint, 1),
                .data(.systemRed, 1)
            ], 1),
        ], 1),
        
    ]
    
}
