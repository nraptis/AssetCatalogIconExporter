//
//  MeasureTool+SixBox.swift
//  JiggleIconAssetBundler
//
//  Created by Nicky Taylor on 6/10/24.
//

import Foundation

extension MeasureTool {
    
    static func getSixBox(iconSet: IconSet) -> SixBox {
        
        let page = iconSet.getReferencePage()
        
        if ((page.width % 6) != 0) { fatalError("Slice: \(page): Illegal Width (Mod-6)") }
        if ((page.height % 6) != 0) { fatalError("Slice: \(page): Illegal Height (Mod-6)") }
        
        var insetsLeft = page.insets.left
        var insetsRight = page.insets.right
        var insetsTop = page.insets.top
        var insetsBottom = page.insets.bottom
        var insets = [insetsLeft, insetsRight, insetsTop, insetsBottom]
        for insetIndex in 0..<insets.count {
            var inset = insets[insetIndex]
            if ((inset % 6) == 0) {
                
            } else if (((inset - 1) % 6) == 0) {
                inset -= 1
            } else if (((inset - 2) % 6) == 0) {
                inset -= 2
            } else if (((inset + 1) % 6) == 0) {
                inset += 1
            } else if (((inset + 2) % 6) == 0) {
                inset += 2
            } else if (((inset + 3) % 6) == 0) {
                inset += 3
            } else if (((inset + 4) % 6) == 0) {
                inset += 4
            }
            
            insets[insetIndex] = inset
        }
        insetsLeft = insets[0]
        insetsRight = insets[1]
        insetsTop = insets[2]
        insetsBottom = insets[3]
        
        let left = insetsLeft
        let top = insetsTop
        let right = page.width - (insetsRight)
        let bottom = page.height - (insetsBottom)
        
        if ((right % 6) != 0) { fatalError("Slice: \(page): Illegal right (Mod-6)") }
        if ((bottom % 6) != 0) { fatalError("Slice: \(page): Illegal bottom (Mod-6)") }
        
        let width = (right - left)
        let height = (bottom - top)
        
        if ((left % 6) != 0) { fatalError("Slice: \(page): Illegal left (Mod-6)") }
        if ((top % 6) != 0) { fatalError("Slice: \(page): Illegal top (Mod-6)") }
        if ((width % 6) != 0) { fatalError("Slice: \(page): Illegal 2nd Width (Mod-6)") }
        if ((height % 6) != 0) { fatalError("Slice: \(page): Illegal 2nd Height (Mod-6)") }
        
        return SixBox(imageWidth: page.width / 6,
                      imageHeight: page.height / 6,
                      x: left / 6,
                      y: top / 6,
                      width: width / 6,
                      height: height / 6)
    }
    
}
