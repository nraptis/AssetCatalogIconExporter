//
//  Bitmap.swift
//  Jiggle3
//
//  Created by Nicky Taylor on 6/6/24.
//

import Foundation

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

class Bitmap {

    var rgba: [[RGBA]]
    var width: Int
    var height: Int
    
    struct RGBA {
        let r: UInt8
        let g: UInt8
        let b: UInt8
        let a: UInt8
    }
    
    struct Insets {
        let left: Int
        let top: Int
        let right: Int
        let bottom: Int
    }
    
    init() {
        rgba = [[RGBA]]()
        width = 0
        height = 0
    }
    
    init(cgImage: CGImage?) {
        guard let cgImage = cgImage else {
            rgba = [[RGBA]]()
            width = 0
            height = 0
            return
        }
        
        width = cgImage.width
        height = cgImage.height
        if width <= 0 || height <= 0 {
            rgba = [[RGBA]]()
            self.width = 0
            self.height = 0
            return
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapData = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * bytesPerPixel)
        defer {
            bitmapData.deallocate()
        }
        
        let context = CGContext(data: bitmapData, 
                                width: width,
                                height: height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        let rectangle = CGRect(x: 0, y: 0, width: width, height: height)
        context?.clear(rectangle)
        context?.draw(cgImage, in: rectangle)
        var _rgba: [[RGBA]] = Array(repeating: Array(repeating: RGBA(r: 0, g: 0, b: 0, a: 0), count: height), count: width)
        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * width + x) * bytesPerPixel
                let r = bitmapData[offset]
                let g = bitmapData[offset + 1]
                let b = bitmapData[offset + 2]
                let a = bitmapData[offset + 3]
                _rgba[x][y] = RGBA(r: r, g: g, b: b, a: a)
            }
        }
        self.rgba = _rgba
    }
    
    func printData() {
        
        print("@@ Start ==> Bitmap [\(width) x \(height)]")
        
        for y in 0..<height {
            
            var rowString = String(y)
            if rowString.count < 4 {
                rowString.insert(contentsOf: [Character](repeating: "0", count: (4 - rowString.count)), at: rowString.startIndex)
            }
            
            var dataString = ""
            for x in 0..<width {
                let chunk = rgba[x][y]
                var chunkString = "[" + String(chunk.r) + ", " + String(chunk.g) + ", " + String(chunk.b) + ", " + String(chunk.a) + "]"
                
                if (x == (width - 1)) {
                    dataString += chunkString
                } else {
                    dataString += chunkString + ", "
                }
            }
            var string = "@ \(rowString) => \(dataString)"
            print(string)
        }
        print("@@ End ==> Bitmap [\(width) x \(height)]")
    }
    
    func getInsets(minimumAlpha: Int = 16) -> Insets {
        
        var left = 0
        var top = 0
        var right = 0
        var bottom = 0
        
        if width > 0 && height > 0 {
            var isAnyPixelOpaque = false
            for x in 0..<width {
                for y in 0..<height {
                    if rgba[x][y].a >= minimumAlpha {
                        isAnyPixelOpaque = true
                    }
                }
            }
            
            if isAnyPixelOpaque == false {
                left = width
                right = 0
                top = height
                bottom = 0
            } else {
                var x = 0
                var y = 0
            OUTER: while left < width {
                y = 0
                while y < height {
                    if rgba[0 + left][y].a >= minimumAlpha {
                        break OUTER
                    }
                    y += 1
                }
                left += 1
            }
                
            OUTER: while right < width {
                y = 0
                while y < height {
                    if rgba[width - 1 - right][y].a >= minimumAlpha {
                        break OUTER
                    }
                    y += 1
                }
                right += 1
            }
                
            OUTER: while top < height {
                x = 0
                while x < width {
                    if rgba[x][top].a >= minimumAlpha {
                        break OUTER
                    }
                    x += 1
                }
                top += 1
            }
                
            OUTER: while bottom < height {
                x = 0
                while x < width {
                    if rgba[x][height - 1 - bottom].a >= minimumAlpha {
                        break OUTER
                    }
                    x += 1
                }
                bottom += 1
            }
            }
        }
        return Insets(left: left, top: top, right: right, bottom: bottom)
    }
}
