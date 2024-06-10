//
//  Classification.swift
//  JiggleIconAssetBundler
//
//  Created by Nicky Taylor on 6/10/24.
//

import Foundation

enum Classification {
    
    case pad0Lines
    case pad1Line
    case pad2Lines
    
    case phoneLandscape0Lines
    case phoneLandscape1Line
    case phoneLandscape2Lines
    
    case phonePortrait0Lines
    case phonePortrait1Line
    case phonePortrait2Lines
    
    var scales: [Scale] {
        switch self {
        case .pad0Lines:
            return [.X1_0, .X2_0]
        case .pad1Line:
            return [.X1_0, .X2_0]
        case .pad2Lines:
            return [.X1_0, .X2_0]
        case .phoneLandscape0Lines:
            return [.X1_0, .X2_0, .X3_0]
        case .phoneLandscape1Line:
            return [.X1_0, .X2_0, .X3_0]
        case .phoneLandscape2Lines:
            return [.X1_0, .X2_0, .X3_0]
        case .phonePortrait0Lines:
            return [.X1_0, .X2_0, .X3_0]
        case .phonePortrait1Line:
            return [.X1_0, .X2_0, .X3_0]
        case .phonePortrait2Lines:
            return [.X1_0, .X2_0, .X3_0]
        }
    }
    
    var nameComponent: String {
        switch self {
        case .pad0Lines:
            "pad_0l"
        case .pad1Line:
            "pad_1l"
        case .pad2Lines:
            "pad_2l"
        case .phoneLandscape0Lines:
            "phone_ls_0l"
        case .phoneLandscape1Line:
            "phone_ls_1l"
        case .phoneLandscape2Lines:
            "phone_ls_2l"
        case .phonePortrait0Lines:
            "phone_po_0l"
        case .phonePortrait1Line:
            "phone_po_1l"
        case .phonePortrait2Lines:
            "phone_po_2l"
        }
    }
    
    var device: Device {
        switch self {
        case .pad1Line:
            return .pad
        case .pad2Lines:
            return .pad
        case .pad0Lines:
            return .pad
        case .phoneLandscape1Line:
            return .phone
        case .phoneLandscape2Lines:
            return .phone
        case .phoneLandscape0Lines:
            return .phone
        case .phonePortrait1Line:
            return .phone
        case .phonePortrait2Lines:
            return .phone
        case .phonePortrait0Lines:
            return .phone
        }
    }
    
    var orientation: Orientation? {
        switch self {
        case .pad1Line:
            return nil
        case .pad2Lines:
            return nil
        case .pad0Lines:
            return nil
        case .phoneLandscape1Line:
            return .landscape
        case .phoneLandscape2Lines:
            return .landscape
        case .phoneLandscape0Lines:
            return .landscape
        case .phonePortrait1Line:
            return .portrait
        case .phonePortrait2Lines:
            return .portrait
        case .phonePortrait0Lines:
            return .portrait
        }
    }
}
