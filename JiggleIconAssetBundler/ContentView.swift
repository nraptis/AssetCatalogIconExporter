//
//  ContentView.swift
//  JiggleIconAssetBundler
//
//  Created by Nicky Taylor on 6/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            
            //MeasureTool.goTextIconButtonButton(filePrefix: "interface_text_button_box", variableName: "box")

            
            //MeasureTool.checkBoxBuildAsset(name: "sample")
            //MeasureTool.checkBoxBuildAsset(name: "remove_points")
            
            
            //MeasureTool.checkBoxBuildAsset(name: "remove_points")
            //MeasureTool.checkBoxBuildAsset(name: "add_points")
            
            
            MeasureTool.textButtonBuildAsset(name: "remove_point")
            
            //MeasureTool.textButtonBuildAsset(name: "redo")
            
            
            //MeasureTool.goTextIconButtonButton(filePrefix: "interface_text_button_box", variableName: "dice")

            
            
            
            /*
            interface_text_button_box
            
            let filePath1 = FileUtils.shared.getMainBundleFilePath(fileName: "dimp_01.png")
            if let image = FileUtils.shared.loadImage(filePath1) {
                if let cgImage = image.cgImage(forProposedRect: nil,
                                               context: nil,
                                               hints: nil) {
                    let bitmap = Bitmap(cgImage: cgImage)
                    bitmap.printData()
                    let edges = bitmap.getInsets()
                    print("edges.left: \(edges.left)")
                    print("edges.right: \(edges.right)")
                    print("edges.top: \(edges.top)")
                    print("edges.bottom: \(edges.bottom)")
                    
                    
                }
            }
            let filePath2 = FileUtils.shared.getMainBundleFilePath(fileName: "dimp_02.png")
            if let image = FileUtils.shared.loadImage(filePath2) {
                if let cgImage = image.cgImage(forProposedRect: nil,
                                               context: nil,
                                               hints: nil) {
                    let bitmap = Bitmap(cgImage: cgImage)
                    let edges = bitmap.getInsets()
                    print("2 edges.left: \(edges.left)")
                    print("2 edges.right: \(edges.right)")
                    print("2 edges.top: \(edges.top)")
                    print("2 edges.bottom: \(edges.bottom)")
                }
            }
            let filePath3 = FileUtils.shared.getMainBundleFilePath(fileName: "dimp_03.png")
            if let image = FileUtils.shared.loadImage(filePath3) {
                if let cgImage = image.cgImage(forProposedRect: nil,
                                               context: nil,
                                               hints: nil) {
                    let bitmap = Bitmap(cgImage: cgImage)
                    let edges = bitmap.getInsets()
                    print("3 edges.left: \(edges.left)")
                    print("3 edges.right: \(edges.right)")
                    print("3 edges.top: \(edges.top)")
                    print("3 edges.bottom: \(edges.bottom)")
                }
            }
            let filePath4 = FileUtils.shared.getMainBundleFilePath(fileName: "dimp_04.png")
            if let image = FileUtils.shared.loadImage(filePath4) {
                if let cgImage = image.cgImage(forProposedRect: nil,
                                               context: nil,
                                               hints: nil) {
                    let bitmap = Bitmap(cgImage: cgImage)
                    let edges = bitmap.getInsets()
                    print("4 edges.left: \(edges.left)")
                    print("4 edges.right: \(edges.right)")
                    print("4 edges.top: \(edges.top)")
                    print("4 edges.bottom: \(edges.bottom)")
                }
            }
            
            
            //dimp_04.png
            //dimp_03.png
            //dimp_02.png
            
            exit(0)
            */
        }
    }
}

#Preview {
    ContentView()
}
