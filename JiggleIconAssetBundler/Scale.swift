//
//  Scale.swift
//  JiggleIconAssetBundler
//
//  Created by Nicky Taylor on 6/10/24.
//

import Foundation

enum Scale: UInt8 {
    
    case X1_0
    case X2_0
    case X3_0
    case X4_0
    case X6_0
    
    var nameComponent: String {
        switch self {
        case .X1_0:
            return "1_0"
        case .X2_0:
            return "2_0"
        case .X3_0:
            return "3_0"
        case .X4_0:
            return "4_0"
        case .X6_0:
            return "6_0"
        }
    }
    
    var catalogScaleComponent: String {
        switch self {
        case .X1_0:
            return "1x"
        case .X2_0:
            return "2x"
        case .X3_0:
            return "3x"
        case .X4_0:
            return "4x"
        case .X6_0:
            return "5x"
        }
    }
}

extension Scale: Equatable {
    static func == (lhs: Scale, rhs: Scale) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
