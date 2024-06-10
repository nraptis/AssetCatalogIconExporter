//
//  Orientation.swift
//  Jiggle III
//
//  Created by Nicky Taylor on 11/8/23.
//

enum Orientation {
    case landscape
    case portrait

    var isPortrait: Bool {
        switch self {
        case .landscape:
            return false
        case .portrait:
            return true
        }
    }
    var isLandscape: Bool {
        switch self {
        case .landscape:
            return true
        case .portrait:
            return false
        }
    }
}

extension Orientation: CustomStringConvertible {
    var description: String {
        switch self {
        case .portrait:
            return "[P]"
        case .landscape:
            return "[L]"
        }
    }
}
