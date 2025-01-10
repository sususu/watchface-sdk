//
//  SifliQjsWatchface.swift
//  WatchfaceSDK
//
//  Created by HuaWo on 2024/8/2.
//

import UIKit

public class SifliQjsWatchface: NSObject {
    var id: Int64 = 0
    var width: Int = 466
    var height: Int = 466
    var widgetList: [Widget] = []
    var name: String
    var thumbnail: UIImage?
    var aod: SifliQjsWatchface?
    var isAOD: Bool = false
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, width: Int, height: Int) {
        self.width = width
        self.height = height
        self.name = name
    }
    
    public func toQjs(_ isAOD: Bool = false) -> String {
        
        let startFunc = QjsFunction(name: "start")
        let pauseFunc = QjsFunction(name: "pause")
        let resumeFunc = QjsFunction(name: "resume")
        let refreshFunc = QjsFunction(name: "refresh")
        let stopFunc = QjsFunction(name: "stop")
        
        var tmpDict: [String: QjsDependence] = [:]
        var dependences = QjsDependence.baseDependences()
        // var dependences: [Dependence] = baseDependences
        for widget in widgetList {
            var key = widget.getDependence()?.module ?? ""
            if let name = widget.dependence?.name {
                key += "_\(name)"
            }
            
            if let dependence = widget.dependence, tmpDict[key] == nil {
                tmpDict[key] = dependence
                dependences.append(dependence)
            }
        }
        
        var sb = ""
        let dependencesStrs: [String] = dependences.map { $0.toQjs(isAOD) }
        let headers = dependencesStrs.joined(separator: "\n")
        let prefix = isAOD ? "AOD_" : "JW_"
        let type = isAOD ? 0 : 1
        sb.append("class \(prefix)\(name) extends app {\n")
        sb += "\tconstructor() {\n"
        sb += "\t\tsuper(\(type));\n"
        sb += "\t}\n" 
        var refreshBody = ""
        var startBody = ""
        var resumeBody = ""
        var pauseBody = "\t\tthis.task();\n"
        var stopBody = ""
        for (index, widget) in widgetList.enumerated() {
            widget.jsVarName = "\(index)"
            if widget.start() != "" {
                startBody += widget.start()
            }
            if widget.resume() != "" {
                resumeBody += widget.resume()
            }
            if widget.pause() != "" {
                pauseBody += widget.pause()
            }
            if widget.stop() != "" {
                stopBody += widget.stop()
            }
        }
        
        if !refreshBody.isEmpty {
            refreshFunc.setBody(refreshBody)
            sb += "\(refreshFunc.toQjs(isAOD))\n"
        }
        
        startFunc.setBody(startBody)
        sb += "\t\(startFunc.toQjs(isAOD))\n"
        if !resumeBody.isEmpty {
            resumeFunc.setBody(resumeBody)
            sb += "\t\(resumeFunc.toQjs(isAOD))\n"
        }
        pauseFunc.setBody(pauseBody)
        sb += "\t\(pauseFunc.toQjs(isAOD))\n"
        if !stopBody.isEmpty {
            stopFunc.setBody(stopBody)
            sb += "\t\(stopFunc.toQjs(isAOD))\n"
        }
        sb += "}\n"
        sb += "globalThis.\(prefix)\(name) = \(prefix)\(name);\n"
        var result = headers + "\n"
        result += sb + "\n"
        return result        
    }
    
    public func makeZip(callback: @escaping (URL?, Error?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            DispatchQueue.main.async {
                if let error = self?.packageZip() {
                    callback(self?.zipUrl, error)
                } else {
                    callback(self?.zipUrl, nil)
                }
            }
            
        }
    }
    
    private var zipUrl: URL?
    private func packageZip() -> Error? {
        if thumbnail == nil {
            return Error.missingThumbnail
        }
        
        let isCreate = QjsFileUtils.createQjsTmpDir(watchfaceName: self.name)
        if !isCreate {
            return Error.createDirError
        }
        
        let success = QjsFileUtils.exportBin(source: thumbnail!, isAOD: false, isTimeHand: false, fileName: "thumb.bin", watchfaceName: self.name)
        if !success {
            return Error.exportBinError
        }

        let error = exportBinFiles(watchface: self,isAOD: false)
        if error != nil {
            return error
        }
        
        if aod != nil {
            let aodError = exportBinFiles(watchface: self.aod!,isAOD: true)
            if aodError != nil {
                return aodError
            }
        }
        
        // 生成QJS
        let mainJS = toQjs()
        var aodJS = ""
        if aod != nil {
            aodJS = aod!.toQjs()
        }
        
        if !mainJS.isEmpty {
            let f = QjsFileUtils.writeMainJS(content: mainJS, isAOD: false, watchfaceName: name)
            if !f {
                return Error.saveQjsFileError
            }
        } else {
            return Error.qjsFileEmpty
        }
        
        if !aodJS.isEmpty {
            let f = QjsFileUtils.writeMainJS(content: aodJS, isAOD: true, watchfaceName: name)
            if !f {
                return Error.saveQjsFileError
            }
        }
        
        guard let url = QjsFileUtils.packageQjs(name) else {
            return Error.zipError
        }
        
        zipUrl = url
        return nil
    }
    
    
    public func copy() -> SifliQjsWatchface {
        let w = SifliQjsWatchface(name: self.name)
        w.width = width
        w.height = height
        w.thumbnail = thumbnail
        w.aod = aod
        w.isAOD = isAOD
        w.name = name
        w.id = id
        w.widgetList = widgetList
        return w
    }
    
    func exportBinFiles(watchface: SifliQjsWatchface, isAOD: Bool) -> Error? {
        var bitmaps: [String: UIImage] = [:]
        var gifs: [String: URL] = [:]
        
        for (i, widget) in widgetList.enumerated() {
            if let lineImageWidget = widget as? LineImageWidget, let image = lineImageWidget.image {
                let imgName = "lineRes\(i).bin"
                lineImageWidget.imagePath = imgName
                bitmaps[imgName] = image
            }
            else if let pointerWidget = widget as? PointerWidget, let image = pointerWidget.image {
                let imgName = "point\(i).bin"
                pointerWidget.imagePath = imgName
                bitmaps[imgName] = image
            }
            else if let imageWidget = widget as? SingleImageWidget, let image = imageWidget.image {
                let imgName = "img\(i).bin"
                imageWidget.imagePath = imgName
                bitmaps[imgName] = image
            }
            else if let optionWidget = widget as? OptionWidget {
                let images = optionWidget.images
                let prefix = "option\(i)_"
                var imagePaths: [String] = []
                for (suffix, bitmap) in images {
                    let imgName = "\(prefix)\(suffix).bin"
                    imagePaths.append(imgName)
                    bitmaps[imgName] = bitmap
                }
                optionWidget.imagePrefix = prefix
                optionWidget.imagePaths = imagePaths
            }
            else if let groupWidget = widget as? GroupWidget {
                let images = groupWidget.images
                let prefix = "group\(i)_"
                var imagePaths: [Int: String] = [:]
                for (key, bitmap) in images {
                    let imgName = "\(prefix)\(String(key, radix: 16)).bin"
                    imagePaths[key] = imgName
                    bitmaps[imgName] = bitmap
                }
                groupWidget.imagePrefix = prefix
                groupWidget.imagePaths = imagePaths
            }
            else if let sequenceImageWidget = widget as? SequenceImageWidget {
                let images = sequenceImageWidget.images
                let prefix = "seq\(i)_"
                for (j, image) in images.enumerated() {
                    let imgName = "\(prefix)\(String(format: "%02d", j)).bin"
                    bitmaps[imgName] = image
                }
                sequenceImageWidget.imagePrefix = prefix
            }
            else if let gifWidget = widget as? GifWidget, let gif = gifWidget.gif, let gifPreview = gifWidget.gifPreview {
                let imgName = "gif\(i).agif"
                let ffImgName = "gif\(i)_ff.bin"
                bitmaps[ffImgName] = gifPreview
                gifs[imgName] = gif
                gifWidget.gifPath = imgName
                gifWidget.gifPreviewPath = ffImgName
            }
        }
        
        // 已经处理完毕，开始导出bin
        for (path, bitmap) in bitmaps {
            let isTimeHand = path.hasPrefix("point")
            let success = QjsFileUtils.exportBin(source: bitmap, isAOD: isAOD, isTimeHand: isTimeHand, fileName: path, watchfaceName: watchface.name)
            if !success {
                return Error.exportBinError
            }
        }
        for (path, gif) in gifs {
            var success = false
            do {
                //URL(fileURLWithPath: gif.path)
                let gifData = try Data(contentsOf: gif)
                success = QjsFileUtils.exportGifBin(source: gifData, isAOD: false, isTimeHand: false, fileName: path, watchfaceName: watchface.name)
            } catch {
                print("无法获取数据: \(error)")
            }
           
            if !success {
                return Error.exportBinError
            }
        }
        return nil
    }
}
