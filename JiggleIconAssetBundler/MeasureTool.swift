//
//  TextIconMeasureTool.swift
//  JiggleIconAssetBundler
//
//  Created by Nicky Taylor on 6/8/24.
//

import Foundation
#if os(macOS)
import Cocoa
#else
import UIKit
#endif

struct Asset {
    let iconSets: [IconSet]
    let name: String
    func getIconSet(classification: Classification) -> IconSet? {
        for iconSet in iconSets {
            if iconSet.classification == classification {
                return iconSet
            }
        }
        return nil
    }
}

struct IconSetPage {
    let name: String
    let scale: Scale
    let insets: Bitmap.Insets
    let width: Int
    let height: Int
    let imageData: Data
    let imageFileName: String
}

struct IconSet {
    let fileName: String
    let classification: Classification
    let device: Device
    let pages: [IconSetPage]
    func getReferencePage() -> IconSetPage {
        for page in pages {
            if page.scale == .X6_0 {
                return page
            }
        }
        fatalError("no 6 page")
    }
    func getPage(scale: Scale) -> IconSetPage? {
        for page in pages {
            if page.scale == scale {
                return page
            }
        }
        return nil
    }
}


class MeasureTool {
    
    static func checkBoxBuildAsset(name: String) {
        let prefix = "check_box"
        let classifications = checkBoxClassifications()
        let scales = getScales()
        let asset = getAsset(prefix: prefix,
                             name: name,
                             classifications: classifications,
                             scales: scales)
        export(asset: asset)
        checkBoxLogAsset(prefix: prefix, name: name, asset: asset)
    }
    
    static func textButtonBuildAsset(name: String) {
        let prefix = "text_button"
        let classifications = checkBoxClassifications()
        let scales = getScales()
        let asset = getAsset(prefix: prefix,
                             name: name,
                             classifications: classifications,
                             scales: scales)
        export(asset: asset)
        textButtonLogAsset(prefix: prefix, name: name, asset: asset)
    }
    
    
    
    static func getAsset(prefix: String, name: String, classifications: [Classification], scales: [Scale]) -> Asset {
        var iconSets = [IconSet]()
        
        for classification in classifications {
            var pages = [IconSetPage]()
            
            for scale in scales {
                let pageName = prefix + "_" + name + "_" + classification.nameComponent + "_" + scale.nameComponent
                let fileName = pageName + ".png"
                let filePath = FileUtils.shared.getMainBundleFilePath(fileName: fileName)
                if let imageData = FileUtils.shared.load(filePath) {
                    if let image = NSImage(data: imageData) {
                        if let cgImage = image.cgImage(forProposedRect: nil,
                                                       context: nil,
                                                       hints: nil) {
                            let bitmap = Bitmap(cgImage: cgImage)
                            guard bitmap.width > 0 && bitmap.height > 0 else {
                                print("[[ BAD BITMAP ]] @ \(fileName) from \(name)")
                                exit(0)
                            }
                            let insets = bitmap.getInsets()
                            let page = IconSetPage(name: pageName,
                                                   scale: scale,
                                                   insets: insets,
                                                   width: bitmap.width,
                                                   height: bitmap.height,
                                                   imageData: imageData,
                                                   imageFileName: filePath)
                            pages.append(page)
                        } else {
                            print("[[ BAD IMAGE ]] @ \(fileName) from \(name)")
                            exit(0)
                        }
                    } else {
                        print("[[ BAD FILE DATA ]] @ \(fileName) from \(name)")
                        exit(0)
                    }
                } else {
                    print("[[ BAD FILE PATH ]] @ \(fileName) from \(name)")
                    exit(0)
                }
            }
            let iconSetFileName = prefix + "_" + name + "_" + classification.nameComponent
            let iconSet = IconSet(fileName: iconSetFileName,
                                  classification: classification,
                                  device: classification.device,
                                  pages: pages)
            _ = iconSet.getReferencePage()
            iconSets.append(iconSet)
        }
        return Asset(iconSets: iconSets,
                     name: prefix + "_" + name)
    }
    
    static func checkBoxClassifications() -> [Classification] {
        let classifications: [Classification] = [
            .pad0Lines,
            .pad1Line,
            .pad2Lines,
            .phonePortrait0Lines,
            .phonePortrait1Line,
            .phonePortrait2Lines,
            .phoneLandscape0Lines,
            .phoneLandscape1Line,
            .phoneLandscape2Lines
        ]
        return classifications
    }
    
    static func getScales() -> [Scale] {
        let scales: [Scale] = [
            .X1_0,
            .X2_0,
            .X3_0,
            .X4_0,
            .X6_0
        ]
        return scales
    }
    
    static func snakeToCamel(string: String) -> String {
        let parts = string.split(separator: "_")
        var result = ""
        
        var index = 0
        while index < parts.count {
            let part = parts[index]
            if part.count > 0 {
                if index == 0 {
                    result += part
                } else {
                    result += part.capitalized
                }
            }
            index += 1
        }
        
        return result
    }
    
    static func checkBoxLogAsset(prefix: String,
                                 name: String,
                                 asset: Asset) {
        
        guard let iconSetPad0Lines = asset.getIconSet(classification: .pad0Lines) else {
            fatalError("iconSetPad0Lines doesn't exist")
        }
        
        guard let iconSetPad1Line = asset.getIconSet(classification: .pad1Line) else {
            fatalError("iconSetPad1Line doesn't exist")
        }
        
        guard let iconSetPad2Lines = asset.getIconSet(classification: .pad2Lines) else {
            fatalError("iconSetPad2Lines doesn't exist")
        }
        
        guard let iconSetPhonePortrait0Lines = asset.getIconSet(classification: .phonePortrait0Lines) else {
            fatalError("iconSetPhonePortrait0Lines doesn't exist")
        }
        
        guard let iconSetPhonePortrait1Line = asset.getIconSet(classification: .phonePortrait1Line) else {
            fatalError("iconSetPhonePortrait1Line doesn't exist")
        }
        
        guard let iconSetPhonePortrait2Lines = asset.getIconSet(classification: .phonePortrait2Lines) else {
            fatalError("iconSetPhonePortrait2Lines doesn't exist")
        }
        
        guard let iconSetPhoneLandscape0Lines = asset.getIconSet(classification: .phoneLandscape0Lines) else {
            fatalError("iconSetPhoneLandscape0Lines doesn't exist")
        }
        
        guard let iconSetPhoneLandscape1Line = asset.getIconSet(classification: .phoneLandscape1Line) else {
            fatalError("iconSetPhoneLandscape1Line doesn't exist")
        }
        
        guard let iconSetPhoneLandscape2Lines = asset.getIconSet(classification: .phoneLandscape2Lines) else {
            fatalError("iconSetPhoneLandscape2Lines doesn't exist")
        }
        
        let slicePad0Lines = getIconPackSlice(iconSet: iconSetPad0Lines)
        let slicePad1Line = getIconPackSlice(iconSet: iconSetPad1Line)
        let slicePad2Lines = getIconPackSlice(iconSet: iconSetPad2Lines)
        
        let slicePhoneLandscape0Lines = getIconPackSlice(iconSet: iconSetPhoneLandscape0Lines)
        let slicePhoneLandscape1Line = getIconPackSlice(iconSet: iconSetPhoneLandscape1Line)
        let slicePhoneLandscape2Lines = getIconPackSlice(iconSet: iconSetPhoneLandscape2Lines)
        
        let slicePhonePortrait0Lines = getIconPackSlice(iconSet: iconSetPhonePortrait0Lines)
        let slicePhonePortrait1Line = getIconPackSlice(iconSet: iconSetPhonePortrait1Line)
        let slicePhonePortrait2Lines = getIconPackSlice(iconSet: iconSetPhonePortrait2Lines)
        
        let variableName = snakeToCamel(string: name)
        let output = """
static var \(variableName): CheckBoxIconPack = {
    let slicePad0Lines = AnyTextIcon(fileName: \"\(iconSetPad0Lines.fileName)\",
                                     device: \(slicePad0Lines.deviceName), orientation: \(slicePad0Lines.orientationName),
                                     imageWidth: \(slicePad0Lines.imageWidth), imageHeight: \(slicePad0Lines.imageHeight),
                                     iconX: \(slicePad0Lines.iconX), iconY: \(slicePad0Lines.iconY), iconWidth: \(slicePad0Lines.iconWidth), iconHeight: \(slicePad0Lines.iconHeight))
    let slicePad1Line = AnyTextIcon(fileName: \"\(iconSetPad1Line.fileName)\",
                                      device: \(slicePad1Line.deviceName), orientation: \(slicePad1Line.orientationName),
                                      imageWidth: \(slicePad1Line.imageWidth), imageHeight: \(slicePad1Line.imageHeight),
                                      iconX: \(slicePad1Line.iconX), iconY: \(slicePad1Line.iconY), iconWidth: \(slicePad1Line.iconWidth), iconHeight: \(slicePad1Line.iconHeight))
    let slicePad2Lines = AnyTextIcon(fileName: \"\(iconSetPad2Lines.fileName)\",
                                       device: \(slicePad2Lines.deviceName), orientation: \(slicePad2Lines.orientationName),
                                       imageWidth: \(slicePad2Lines.imageWidth), imageHeight: \(slicePad2Lines.imageHeight),
                                       iconX: \(slicePad2Lines.iconX), iconY: \(slicePad2Lines.iconY), iconWidth: \(slicePad2Lines.iconWidth), iconHeight: \(slicePad2Lines.iconHeight))
    
    let slicePhoneLandscape0Lines = AnyTextIcon(fileName: \"\(slicePhoneLandscape0Lines.fileName)\",
                                                  device: \(slicePhoneLandscape0Lines.deviceName), orientation: \(slicePhoneLandscape0Lines.orientationName),
                                                  imageWidth: \(slicePhoneLandscape0Lines.imageWidth), imageHeight: \(slicePhoneLandscape0Lines.imageHeight),
                                                  iconX: \(slicePhoneLandscape0Lines.iconX), iconY: \(slicePhoneLandscape0Lines.iconY), iconWidth: \(slicePhoneLandscape0Lines.iconWidth), iconHeight: \(slicePhoneLandscape0Lines.iconHeight))
    let slicePhoneLandscape1Line = AnyTextIcon(fileName: \"\(slicePhoneLandscape1Line.fileName)\",
                                                 device: \(slicePhoneLandscape1Line.deviceName), orientation: \(slicePhoneLandscape1Line.orientationName),
                                                 imageWidth: \(slicePhoneLandscape1Line.imageWidth), imageHeight: \(slicePhoneLandscape1Line.imageHeight),
                                                 iconX: \(slicePhoneLandscape1Line.iconX), iconY: \(slicePhoneLandscape1Line.iconY), iconWidth: \(slicePhoneLandscape1Line.iconWidth), iconHeight: \(slicePhoneLandscape1Line.iconHeight))
    let slicePhoneLandscape2Lines = AnyTextIcon(fileName: \"\(slicePhoneLandscape2Lines.fileName)\",
                                                  device: \(slicePhoneLandscape2Lines.deviceName), orientation: \(slicePhoneLandscape2Lines.orientationName),
                                                  imageWidth: \(slicePhoneLandscape2Lines.imageWidth), imageHeight: \(slicePhoneLandscape2Lines.imageHeight),
                                                  iconX: \(slicePhoneLandscape2Lines.iconX), iconY: \(slicePhoneLandscape2Lines.iconY), iconWidth: \(slicePhoneLandscape2Lines.iconWidth), iconHeight: \(slicePhoneLandscape2Lines.iconHeight))
    
    let slicePhonePortrait0Lines = AnyTextIcon(fileName: \"\(slicePhonePortrait0Lines.fileName)\",
                                                 device: \(slicePhonePortrait0Lines.deviceName), orientation: \(slicePhonePortrait0Lines.orientationName),
                                                 imageWidth: \(slicePhonePortrait0Lines.imageWidth), imageHeight: \(slicePhonePortrait0Lines.imageHeight),
                                                 iconX: \(slicePhonePortrait0Lines.iconX), iconY: \(slicePhonePortrait0Lines.iconY), iconWidth: \(slicePhonePortrait0Lines.iconWidth), iconHeight: \(slicePhonePortrait0Lines.iconHeight))
    let slicePhonePortrait1Line = AnyTextIcon(fileName: \"\(slicePhonePortrait1Line.fileName)\",
                                                device: \(slicePhonePortrait1Line.deviceName), orientation: \(slicePhonePortrait1Line.orientationName),
                                                imageWidth: \(slicePhonePortrait1Line.imageWidth), imageHeight: \(slicePhonePortrait1Line.imageHeight),
                                                iconX: \(slicePhonePortrait1Line.iconX), iconY: \(slicePhonePortrait1Line.iconY), iconWidth: \(slicePhonePortrait1Line.iconWidth), iconHeight: \(slicePhonePortrait1Line.iconHeight))
    let slicePhonePortrait2Lines = AnyTextIcon(fileName: \"\(slicePhonePortrait2Lines.fileName)\",
                                                 device: \(slicePhonePortrait2Lines.deviceName), orientation: \(slicePhonePortrait2Lines.orientationName),
                                                 imageWidth: \(slicePhonePortrait2Lines.imageWidth), imageHeight: \(slicePhonePortrait2Lines.imageHeight),
                                                 iconX: \(slicePhonePortrait2Lines.iconX), iconY: \(slicePhonePortrait2Lines.iconY), iconWidth: \(slicePhonePortrait2Lines.iconWidth), iconHeight: \(slicePhonePortrait2Lines.iconHeight))
    
    return CheckBoxIconPack(slicePad0Lines: slicePad0Lines,
                            slicePad1Line: slicePad1Line,
                            slicePad2Lines: slicePad2Lines,
                            
                            slicePhoneLandscape0Lines: slicePhoneLandscape0Lines,
                            slicePhoneLandscape1Line: slicePhoneLandscape1Line,
                            slicePhoneLandscape2Lines: slicePhoneLandscape2Lines,
                            
                            slicePhonePortrait0Lines: slicePhonePortrait0Lines,
                            slicePhonePortrait1Line: slicePhonePortrait1Line,
                            slicePhonePortrait2Lines: slicePhonePortrait2Lines)
}()
"""
        
        print("")
        print(output)
        print("")
        
        
    }
    
    static func textButtonLogAsset(prefix: String,
                                 name: String,
                                 asset: Asset) {
        
        guard let iconSetPad0Lines = asset.getIconSet(classification: .pad0Lines) else {
            fatalError("iconSetPad0Lines doesn't exist")
        }
        
        guard let iconSetPad1Line = asset.getIconSet(classification: .pad1Line) else {
            fatalError("iconSetPad1Line doesn't exist")
        }
        
        guard let iconSetPad2Lines = asset.getIconSet(classification: .pad2Lines) else {
            fatalError("iconSetPad2Lines doesn't exist")
        }
        
        guard let iconSetPhonePortrait0Lines = asset.getIconSet(classification: .phonePortrait0Lines) else {
            fatalError("iconSetPhonePortrait0Lines doesn't exist")
        }
        
        guard let iconSetPhonePortrait1Line = asset.getIconSet(classification: .phonePortrait1Line) else {
            fatalError("iconSetPhonePortrait1Line doesn't exist")
        }
        
        guard let iconSetPhonePortrait2Lines = asset.getIconSet(classification: .phonePortrait2Lines) else {
            fatalError("iconSetPhonePortrait2Lines doesn't exist")
        }
        
        guard let iconSetPhoneLandscape0Lines = asset.getIconSet(classification: .phoneLandscape0Lines) else {
            fatalError("iconSetPhoneLandscape0Lines doesn't exist")
        }
        
        guard let iconSetPhoneLandscape1Line = asset.getIconSet(classification: .phoneLandscape1Line) else {
            fatalError("iconSetPhoneLandscape1Line doesn't exist")
        }
        
        guard let iconSetPhoneLandscape2Lines = asset.getIconSet(classification: .phoneLandscape2Lines) else {
            fatalError("iconSetPhoneLandscape2Lines doesn't exist")
        }
        
        let slicePad0Lines = getIconPackSlice(iconSet: iconSetPad0Lines)
        let slicePad1Line = getIconPackSlice(iconSet: iconSetPad1Line)
        let slicePad2Lines = getIconPackSlice(iconSet: iconSetPad2Lines)
        
        let slicePhoneLandscape0Lines = getIconPackSlice(iconSet: iconSetPhoneLandscape0Lines)
        let slicePhoneLandscape1Line = getIconPackSlice(iconSet: iconSetPhoneLandscape1Line)
        let slicePhoneLandscape2Lines = getIconPackSlice(iconSet: iconSetPhoneLandscape2Lines)
        
        let slicePhonePortrait0Lines = getIconPackSlice(iconSet: iconSetPhonePortrait0Lines)
        let slicePhonePortrait1Line = getIconPackSlice(iconSet: iconSetPhonePortrait1Line)
        let slicePhonePortrait2Lines = getIconPackSlice(iconSet: iconSetPhonePortrait2Lines)
        
        let variableName = snakeToCamel(string: name)
        let output = """
static var \(variableName): TextIconButtonIconPack = {
    let slicePad0Lines = AnyTextIcon(fileName: \"\(iconSetPad0Lines.fileName)\",
                                     device: \(slicePad0Lines.deviceName), orientation: \(slicePad0Lines.orientationName),
                                     imageWidth: \(slicePad0Lines.imageWidth), imageHeight: \(slicePad0Lines.imageHeight),
                                     iconX: \(slicePad0Lines.iconX), iconY: \(slicePad0Lines.iconY), iconWidth: \(slicePad0Lines.iconWidth), iconHeight: \(slicePad0Lines.iconHeight))
    let slicePad1Line = AnyTextIcon(fileName: \"\(iconSetPad1Line.fileName)\",
                                      device: \(slicePad1Line.deviceName), orientation: \(slicePad1Line.orientationName),
                                      imageWidth: \(slicePad1Line.imageWidth), imageHeight: \(slicePad1Line.imageHeight),
                                      iconX: \(slicePad1Line.iconX), iconY: \(slicePad1Line.iconY), iconWidth: \(slicePad1Line.iconWidth), iconHeight: \(slicePad1Line.iconHeight))
    let slicePad2Lines = AnyTextIcon(fileName: \"\(iconSetPad2Lines.fileName)\",
                                       device: \(slicePad2Lines.deviceName), orientation: \(slicePad2Lines.orientationName),
                                       imageWidth: \(slicePad2Lines.imageWidth), imageHeight: \(slicePad2Lines.imageHeight),
                                       iconX: \(slicePad2Lines.iconX), iconY: \(slicePad2Lines.iconY), iconWidth: \(slicePad2Lines.iconWidth), iconHeight: \(slicePad2Lines.iconHeight))
    
    let slicePhoneLandscape0Lines = AnyTextIcon(fileName: \"\(slicePhoneLandscape0Lines.fileName)\",
                                                  device: \(slicePhoneLandscape0Lines.deviceName), orientation: \(slicePhoneLandscape0Lines.orientationName),
                                                  imageWidth: \(slicePhoneLandscape0Lines.imageWidth), imageHeight: \(slicePhoneLandscape0Lines.imageHeight),
                                                  iconX: \(slicePhoneLandscape0Lines.iconX), iconY: \(slicePhoneLandscape0Lines.iconY), iconWidth: \(slicePhoneLandscape0Lines.iconWidth), iconHeight: \(slicePhoneLandscape0Lines.iconHeight))
    let slicePhoneLandscape1Line = AnyTextIcon(fileName: \"\(slicePhoneLandscape1Line.fileName)\",
                                                 device: \(slicePhoneLandscape1Line.deviceName), orientation: \(slicePhoneLandscape1Line.orientationName),
                                                 imageWidth: \(slicePhoneLandscape1Line.imageWidth), imageHeight: \(slicePhoneLandscape1Line.imageHeight),
                                                 iconX: \(slicePhoneLandscape1Line.iconX), iconY: \(slicePhoneLandscape1Line.iconY), iconWidth: \(slicePhoneLandscape1Line.iconWidth), iconHeight: \(slicePhoneLandscape1Line.iconHeight))
    let slicePhoneLandscape2Lines = AnyTextIcon(fileName: \"\(slicePhoneLandscape2Lines.fileName)\",
                                                  device: \(slicePhoneLandscape2Lines.deviceName), orientation: \(slicePhoneLandscape2Lines.orientationName),
                                                  imageWidth: \(slicePhoneLandscape2Lines.imageWidth), imageHeight: \(slicePhoneLandscape2Lines.imageHeight),
                                                  iconX: \(slicePhoneLandscape2Lines.iconX), iconY: \(slicePhoneLandscape2Lines.iconY), iconWidth: \(slicePhoneLandscape2Lines.iconWidth), iconHeight: \(slicePhoneLandscape2Lines.iconHeight))
    
    let slicePhonePortrait0Lines = AnyTextIcon(fileName: \"\(slicePhonePortrait0Lines.fileName)\",
                                                 device: \(slicePhonePortrait0Lines.deviceName), orientation: \(slicePhonePortrait0Lines.orientationName),
                                                 imageWidth: \(slicePhonePortrait0Lines.imageWidth), imageHeight: \(slicePhonePortrait0Lines.imageHeight),
                                                 iconX: \(slicePhonePortrait0Lines.iconX), iconY: \(slicePhonePortrait0Lines.iconY), iconWidth: \(slicePhonePortrait0Lines.iconWidth), iconHeight: \(slicePhonePortrait0Lines.iconHeight))
    let slicePhonePortrait1Line = AnyTextIcon(fileName: \"\(slicePhonePortrait1Line.fileName)\",
                                                device: \(slicePhonePortrait1Line.deviceName), orientation: \(slicePhonePortrait1Line.orientationName),
                                                imageWidth: \(slicePhonePortrait1Line.imageWidth), imageHeight: \(slicePhonePortrait1Line.imageHeight),
                                                iconX: \(slicePhonePortrait1Line.iconX), iconY: \(slicePhonePortrait1Line.iconY), iconWidth: \(slicePhonePortrait1Line.iconWidth), iconHeight: \(slicePhonePortrait1Line.iconHeight))
    let slicePhonePortrait2Lines = AnyTextIcon(fileName: \"\(slicePhonePortrait2Lines.fileName)\",
                                                 device: \(slicePhonePortrait2Lines.deviceName), orientation: \(slicePhonePortrait2Lines.orientationName),
                                                 imageWidth: \(slicePhonePortrait2Lines.imageWidth), imageHeight: \(slicePhonePortrait2Lines.imageHeight),
                                                 iconX: \(slicePhonePortrait2Lines.iconX), iconY: \(slicePhonePortrait2Lines.iconY), iconWidth: \(slicePhonePortrait2Lines.iconWidth), iconHeight: \(slicePhonePortrait2Lines.iconHeight))
    
    return TextIconButtonIconPack(slicePad0Lines: slicePad0Lines,
                                slicePad1Line: slicePad1Line,
                                slicePad2Lines: slicePad2Lines,
                            
                                slicePhoneLandscape0Lines: slicePhoneLandscape0Lines,
                                slicePhoneLandscape1Line: slicePhoneLandscape1Line,
                                slicePhoneLandscape2Lines: slicePhoneLandscape2Lines,
                            
                                slicePhonePortrait0Lines: slicePhonePortrait0Lines,
                                slicePhonePortrait1Line: slicePhonePortrait1Line,
                                slicePhonePortrait2Lines: slicePhonePortrait2Lines)
}()
"""
        
        print("")
        print(output)
        print("")
        
        
    }
    
    static func getIconPackSlice(iconSet: IconSet) -> AnyTextIcon {
        let sixBox = getSixBox(iconSet: iconSet)
        
        var orientationName = "nil"
        if let orientation = iconSet.classification.orientation {
            switch orientation {
            case .landscape:
                orientationName = ".landscape"
            case .portrait:
                orientationName = ".portrait"
            }
        }
        
        return AnyTextIcon(fileName: iconSet.fileName,
                           device: iconSet.device,
                           orientation: iconSet.classification.orientation,
                           imageWidth: sixBox.imageWidth,
                           imageHeight: sixBox.imageHeight,
                           iconX: sixBox.x,
                           iconY: sixBox.y,
                           iconWidth: sixBox.width,
                           iconHeight: sixBox.height,
                           orientationName: orientationName,
                           deviceName: ((iconSet.classification.device == .pad) ? ".pad" : ".phone"))
    }
    
    /*
    static func goTextIconButtonButton(filePrefix: String, variableName: String) {
        
        var classifications = [Classification]()
        
        classifications.append(.pad1Line)
        classifications.append(.pad2Lines)
        classifications.append(.pad0Lines)
        
        classifications.append(.phoneLandscape1Line)
        classifications.append(.phoneLandscape2Lines)
        classifications.append(.phoneLandscape0Lines)
        
        classifications.append(.phonePortrait1Line)
        classifications.append(.phonePortrait2Lines)
        classifications.append(.phonePortrait0Lines)
        
        let slices = gogogo(filePrefix: filePrefix, variableName: variableName, classifications: classifications)
        
        guard let _slicePad1Line = slices.filter({ $0.classification == .pad1Line }).first else {
            fatalError("slicePad1Line doesn't exist")
        }
        guard let _slicePad2Lines = slices.filter({ $0.classification == .pad2Lines }).first else {
            fatalError("pad2Lines doesn't exist")
        }
        guard let _slicePad0Lines = slices.filter({ $0.classification == .pad0Lines }).first else {
            fatalError("pad0Lines doesn't exist")
        }
        guard let _slicePhoneLandscape1Line = slices.filter({ $0.classification == .phoneLandscape1Line }).first else {
            fatalError("phoneLandscape1Line doesn't exist")
        }
        guard let _slicePhoneLandscape2Lines = slices.filter({ $0.classification == .phoneLandscape2Lines }).first else {
            fatalError("phoneLandscape2Lines doesn't exist")
        }
        guard let _slicePhoneLandscape0Lines = slices.filter({ $0.classification == .phoneLandscape0Lines }).first else {
            fatalError("phoneLandscape0Lines doesn't exist")
        }
        guard let _slicePhonePortrait1Line = slices.filter({ $0.classification == .phonePortrait1Line }).first else {
            fatalError("phonePortrait1Line doesn't exist")
        }
        guard let _slicePhonePortrait2Lines = slices.filter({ $0.classification == .phonePortrait2Lines }).first else {
            fatalError("phonePortrait2Lines doesn't exist")
        }
        guard let _slicePhonePortrait0Lines = slices.filter({ $0.classification == .phonePortrait0Lines }).first else {
            fatalError("phonePortrait0Lines doesn't exist")
        }
        
        let slicePad1Line = getIconPackSlice(slice: _slicePad1Line)
        let slicePad2Lines = getIconPackSlice(slice: _slicePad2Lines)
        let slicePad0Lines = getIconPackSlice(slice: _slicePad0Lines)
        
        let slicePhoneLandscape1Line = getIconPackSlice(slice: _slicePhoneLandscape1Line)
        let slicePhoneLandscape2Lines = getIconPackSlice(slice: _slicePhoneLandscape2Lines)
        let slicePhoneLandscape0Lines = getIconPackSlice(slice: _slicePhoneLandscape0Lines)
        
        let slicePhonePortrait1Line = getIconPackSlice(slice: _slicePhonePortrait1Line)
        let slicePhonePortrait2Lines = getIconPackSlice(slice: _slicePhonePortrait2Lines)
        let slicePhonePortrait0Lines = getIconPackSlice(slice: _slicePhonePortrait0Lines)
        
        let output = """
static var \(variableName): TextIconButtonIconPack = {
    let slicePad1Line = IconPackSlice(device: \(slicePad1Line.deviceName), orientation: \(slicePad1Line.orientationName),
                                      imageWidth: \(slicePad1Line.imageWidth), imageHeight: \(slicePad1Line.imageHeight),
                                      iconX: \(slicePad1Line.iconX), iconY: \(slicePad1Line.iconY), iconWidth: \(slicePad1Line.iconWidth), iconHeight: \(slicePad1Line.iconHeight))
    let slicePad2Lines = IconPackSlice(device: \(slicePad2Lines.deviceName), orientation: \(slicePad2Lines.orientationName),
                                       imageWidth: \(slicePad2Lines.imageWidth), imageHeight: \(slicePad2Lines.imageHeight),
                                       iconX: \(slicePad2Lines.iconX), iconY: \(slicePad2Lines.iconY), iconWidth: \(slicePad2Lines.iconWidth), iconHeight: \(slicePad2Lines.iconHeight))
    let slicePad0Lines = IconPackSlice(device: \(slicePad0Lines.deviceName), orientation: \(slicePad0Lines.orientationName),
                                      imageWidth: \(slicePad0Lines.imageWidth), imageHeight: \(slicePad0Lines.imageHeight),
                                      iconX: \(slicePad0Lines.iconX), iconY: \(slicePad0Lines.iconY), iconWidth: \(slicePad0Lines.iconWidth), iconHeight: \(slicePad0Lines.iconHeight))
    let slicePhoneLandscape1Line = IconPackSlice(device: \(slicePhoneLandscape1Line.deviceName), orientation: \(slicePhoneLandscape1Line.orientationName),
                                                 imageWidth: \(slicePhoneLandscape1Line.imageWidth), imageHeight: \(slicePhoneLandscape1Line.imageHeight),
                                                 iconX: \(slicePhoneLandscape1Line.iconX), iconY: \(slicePhoneLandscape1Line.iconY), iconWidth: \(slicePhoneLandscape1Line.iconWidth), iconHeight: \(slicePhoneLandscape1Line.iconHeight))
    let slicePhoneLandscape2Lines = IconPackSlice(device: \(slicePhoneLandscape2Lines.deviceName), orientation: \(slicePhoneLandscape2Lines.orientationName),
                                                  imageWidth: \(slicePhoneLandscape2Lines.imageWidth), imageHeight: \(slicePhoneLandscape2Lines.imageHeight),
                                                  iconX: \(slicePhoneLandscape2Lines.iconX), iconY: \(slicePhoneLandscape2Lines.iconY), iconWidth: \(slicePhoneLandscape2Lines.iconWidth), iconHeight: \(slicePhoneLandscape2Lines.iconHeight))
    let slicePhoneLandscape0Lines = IconPackSlice(device: \(slicePhoneLandscape0Lines.deviceName), orientation: \(slicePhoneLandscape0Lines.orientationName),
                                                 imageWidth: \(slicePhoneLandscape0Lines.imageWidth), imageHeight: \(slicePhoneLandscape0Lines.imageHeight),
                                                 iconX: \(slicePhoneLandscape0Lines.iconX), iconY: \(slicePhoneLandscape0Lines.iconY), iconWidth: \(slicePhoneLandscape0Lines.iconWidth), iconHeight: \(slicePhoneLandscape0Lines.iconHeight))
    let slicePhonePortrait1Line = IconPackSlice(device: \(slicePhonePortrait1Line.deviceName), orientation: \(slicePhonePortrait1Line.orientationName),
                                                imageWidth: \(slicePhonePortrait1Line.imageWidth), imageHeight: \(slicePhonePortrait1Line.imageHeight),
                                                iconX: \(slicePhonePortrait1Line.iconX), iconY: \(slicePhonePortrait1Line.iconY), iconWidth: \(slicePhonePortrait1Line.iconWidth), iconHeight: \(slicePhonePortrait1Line.iconHeight))
    let slicePhonePortrait2Lines = IconPackSlice(device: \(slicePhonePortrait2Lines.deviceName), orientation: \(slicePhonePortrait2Lines.orientationName),
                                                 imageWidth: \(slicePhonePortrait2Lines.imageWidth), imageHeight: \(slicePhonePortrait2Lines.imageHeight),
                                                 iconX: \(slicePhonePortrait2Lines.iconX), iconY: \(slicePhonePortrait2Lines.iconY), iconWidth: \(slicePhonePortrait2Lines.iconWidth), iconHeight: \(slicePhonePortrait2Lines.iconHeight))
    let slicePhonePortrait0Lines = IconPackSlice(device: \(slicePhonePortrait0Lines.deviceName), orientation: \(slicePhonePortrait0Lines.orientationName),
                                                imageWidth: \(slicePhonePortrait0Lines.imageWidth), imageHeight: \(slicePhonePortrait0Lines.imageHeight),
                                                iconX: \(slicePhonePortrait0Lines.iconX), iconY: \(slicePhonePortrait0Lines.iconY), iconWidth: \(slicePhonePortrait0Lines.iconWidth), iconHeight: \(slicePhonePortrait0Lines.iconHeight))
    return TextIconButtonIconPack(fileName: \"\(filePrefix)\",
                                  slicePad1Line: slicePad1Line,
                                  slicePad2Lines: slicePad2Lines,
                                  slicePad0Lines: slicePad0Lines,
                                  slicePhoneLandscape1Line: slicePhoneLandscape1Line,
                                  slicePhoneLandscape2Lines: slicePhoneLandscape2Lines,
                                  slicePhoneLandscape0Lines: slicePhoneLandscape0Lines,
                                  slicePhonePortrait1Line: slicePhonePortrait1Line,
                                  slicePhonePortrait2Lines: slicePhonePortrait2Lines,
                                  slicePhonePortrait0Lines: slicePhonePortrait0Lines)
}()
"""
        
        print("")
        print(output)
        print("")
        
    }
    
    static func getIconPackSlice(slice: Slice) -> IconPackSlice {
        let sixBox = getSixBox(slice: slice)
        return IconPackSlice(device: slice.device,
                             orientation: slice.classification.orientation,
                             imageWidth: sixBox.imageWidth,
                             imageHeight: sixBox.imageHeight,
                             iconX: sixBox.x,
                             iconY: sixBox.y,
                             iconWidth: sixBox.width,
                             iconHeight: sixBox.height,
                             orientationName: ((slice.classification.orientation == .landscape) ? ".landscape" : ".portrait"),
                             deviceName: ((slice.classification.device == .pad) ? ".pad" : ".phone"))
    }
    
    
    
    static func gogogo(filePrefix: String, variableName: String, classifications: [Classification]) -> [Slice] {
        
        var slices = [Slice]()
        for classification in classifications {
            
            var fileName = filePrefix + "_" + classification.nameComponent + ".png"
            let filePath = FileUtils.shared.getMainBundleFilePath(fileName: fileName)
            if let image = FileUtils.shared.loadImage(filePath) {
                if let cgImage = image.cgImage(forProposedRect: nil,
                                               context: nil,
                                               hints: nil) {
                    let bitmap = Bitmap(cgImage: cgImage)
                    guard bitmap.width > 0 && bitmap.height > 0 else {
                        print("[[ BAD BITMAP ]] @ \(classification.nameComponent) from \(filePrefix)")
                        exit(0)
                    }
                    
                    let insets = bitmap.getInsets()
                    
                    print("insets got: \(insets)")
                    
                    let slice = Slice(classification: classification,
                                      device: classification.device,
                                      insets: insets,
                                      width: bitmap.width,
                                      height: bitmap.height,
                                      fileName: fileName)
                    slices.append(slice)
                } else {
                    print("[[ BAD IMAGE ]] @ \(classification.nameComponent) from \(filePrefix)")
                    exit(0)
                }
            } else {
                print("[[ BAD FILE PATH ]] @ \(classification.nameComponent) from \(filePrefix)")
                exit(0)
            }
        }
        if slices.count < classifications.count {
            print("Didn't get all the slices...")
            return []
        }
        
        for slice in slices {
            print("Slice: \(slice)")
        }
        
        return slices
    }
     
    */
    
}
