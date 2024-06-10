//
//  IconPackSlice.swift
//  JiggleIconAssetBundler
//
//  Created by Nicky Taylor on 6/8/24.
//

import Foundation

class AnyTextIcon {
    let fileName: String
    let imageWidth: Int
    let imageHeight: Int
    var iconX: Int
    var iconY: Int
    let iconWidth: Int
    let iconHeight: Int
    var device: Device
    var orientation: Orientation?
    let orientationName: String
    let deviceName: String
    
    init(fileName: String,
         device: Device,
         orientation: Orientation?,
         imageWidth: Int,
         imageHeight: Int,
         iconX: Int,
         iconY: Int,
         iconWidth: Int,
         iconHeight: Int,
         orientationName: String,
         deviceName: String) {
        self.fileName = fileName
        self.device = device
        self.orientation = orientation
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.iconX = iconX
        self.iconY = iconY
        self.iconWidth = iconWidth
        self.iconHeight = iconHeight
        self.orientationName = orientationName
        self.deviceName = deviceName
    }
}
