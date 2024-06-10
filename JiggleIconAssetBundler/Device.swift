//
//  Device.swift
//  JiggleIconAssetBundler
//
//  Created by Nicky Taylor on 6/8/24.
//

import Foundation

enum Device {
    case pad
    case phone
    var nameComponent: String {
        switch self {
        case .pad:
            return "pad"
        case .phone:
            return "phone"
        }
    }
}
