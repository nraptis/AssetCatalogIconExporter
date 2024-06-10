//
//  MeasureTool+ExportAsset.swift
//  JiggleIconAssetBundler
//
//  Created by Nicky Taylor on 6/10/24.
//

import Foundation

extension MeasureTool {
    
    static func export(asset: Asset) {
        for iconSet in asset.iconSets {
            let catalogAssetName = asset.name + "_" + iconSet.classification.nameComponent
            let json = getJSON(catalogAssetName: catalogAssetName, iconSet: iconSet)
            if let data = json.data(using: .utf8) {
                let fileName = catalogAssetName + ".imageset" + "/Contents.json"
                let filePath = FileUtils.shared.getDocumentPath(fileName: fileName)
                FileUtils.shared.save(data: data, filePath: filePath)
            }
            let scales = iconSet.classification.scales
            for scale in scales {
                let fileName = catalogAssetName + ".imageset" + "/" + catalogAssetName + "_" + scale.nameComponent + ".png"
                let filePath = FileUtils.shared.getDocumentPath(fileName: fileName)
                if let page = iconSet.getPage(scale: scale) {
                    FileUtils.shared.save(data: page.imageData, filePath: filePath)
                }
            }
        }
    }
    
    static func getJSON(catalogAssetName: String, iconSet: IconSet) -> String {
        var result = ""
        result += "{\n"
        result += "\t\"images\": [\n"
        let scales = iconSet.classification.scales
        for scaleIndex in 0..<scales.count {
            let scale = scales[scaleIndex]
            let fileName = catalogAssetName + "_" + scale.nameComponent + ".png"
            var imageString = ""
            let idiom: String
            switch iconSet.device {
            case .pad:
                idiom = "ipad"
            default:
                idiom = "universal"
            }
            imageString += "\t\t{\n"
            imageString += "\t\t\t\"filename\": \"\(fileName)\",\n"
            imageString += "\t\t\t\"idiom\": \"\(idiom)\",\n"
            imageString += "\t\t\t\"scale\": \"\(scale.catalogScaleComponent)\"\n"
            imageString += "\t\t}"
            if scaleIndex != (scales.count - 1) {
                imageString += ","
            }
            imageString += "\n"
            result += imageString
        }
        result += "\t],\n"
        result += "\t\"info\": {\n"
        result += "\t\t\"author\": \"nraptis\",\n"
        result += "\t\t\"version\": 1\n"
        result += "\t}\n"
        result += "}"
        return result
    }
}
