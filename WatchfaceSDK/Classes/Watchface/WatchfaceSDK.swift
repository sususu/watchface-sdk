
import UIKit
import SFDialPlateSDK

public typealias QjsWatchfaceFinishCallback = (Bool, String?, Int,NSNumber) ->()
public typealias QjsWatchfaceProgressCallback = (Int) ->()
public typealias QjsCompresSuccessCallback = (Bool) ->()

@objc public class WatchfaceSDK: NSObject {
    private var hadInit = false
    private static let instance = WatchfaceSDK()
    private var pushManager = SFDialPlateManager.share
    
    @objc public var width: Double = 466.0
    @objc public var height: Double = 466.0
    
    @objc public var ProgressCallback: QjsWatchfaceProgressCallback!
    @objc public var FinishCallback: QjsWatchfaceFinishCallback!
    @objc public var CompressSuccessCallback: QjsCompresSuccessCallback!
    
    @objc public static func getInstance() -> WatchfaceSDK {
        return instance
    }
    
    @objc public func initSDK() {
        hadInit = true
        self.pushManager = SFDialPlateManager.share
    }
    
    //MARK: - Synchronized album
    /// - Parameters:
    ///   - devIdentifier: The identifier string of the target device. Through CBPeripheral. Identifier. UuidString acquisition
    ///   - compressSuccessCallback: Compressed file callback
    ///   - albums: QjsAlbumModel array
    ///   - progressCallback: Synchronization progress callback
    ///   - finishCallback: Synchronization completes the callback
    @objc public func setPictures(devIdentifier: String,compressSuccessCallback: @escaping QjsCompresSuccessCallback, albums: Array<QjsAlbumModel>, progressCallback: @escaping QjsWatchfaceProgressCallback,finishCallback: @escaping QjsWatchfaceFinishCallback) {
        
        DispatchQueue.global().async { [weak self] in
            WatchfaceSDK.instance.ProgressCallback = progressCallback
            WatchfaceSDK.instance.FinishCallback = finishCallback
            WatchfaceSDK.instance.CompressSuccessCallback = compressSuccessCallback
            
            FileUtils.deleteDirectory(directory: URL(fileURLWithPath: QjsAlbumModel().getAlbumSelectTempPath()))
            
            for i in 0..<albums.count {
                let model = albums[i]
                
                //整屏尺寸
                if let resizedImage = self?.resizeImage(image: model.image!, targetSize: CGSize(width: self!.width, height: self!.height)) {
                    FileUtils.exportAlbumBin(source: resizedImage, isTimeHand: false, fileName: "\(model.name!)", folderURL: URL(fileURLWithPath: model.getAlbumSelectTempPath()), isPng: true)
                }
                
                //预览图 1/3屏幕尺寸
                if let preImage = self?.resizeImage(image: model.image!, targetSize: CGSize(width: self!.width / 3.0, height: self!.height / 3.0)) {
                    FileUtils.exportAlbumBin(source: preImage, isTimeHand: false, fileName: "\(model.name!)", folderURL: URL(fileURLWithPath: model.getAlbumSelectTempPath()), isPng: false)
                }
                
            }
            
            FileUtils.packageQjsAlbum { [weak self]state in
                WatchfaceSDK.instance.CompressSuccessCallback(state)
                if state {
                    self?.pushAlbum(devIdentifier: devIdentifier)
                }
            }
         
        }
    }
    
    //MARK: - 调整图片的大小
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //开启推送相册
    func pushAlbum(devIdentifier: String) {
        
        self.pushManager.delegate = self
        
        let albumTmpDir = "output/photo.zip"
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let zipFilePath = tempDirectoryURL.appendingPathComponent(albumTmpDir)
        
        //开启推送
        self.pushManager.pushDialPlate(devIdentifier: devIdentifier, type: 3, zipPath: zipFilePath,withByteAlign: true)
        
    }
    
    //MARK: - Synchronized music
    /// - Parameters:
    ///   - devIdentifier: The identifier string of the target device. Through CBPeripheral. Identifier. UuidString acquisition
    ///   - musicFilePath: The music file must be in the: music/mp3 directory
    ///   - compressSuccessCallback: Compressed file callback
    ///   - progressCallback: Synchronization progress callback
    ///   - finishCallback: Synchronization completes the callback
    @objc public func setMusicFiles(devIdentifier: String, musicFilePath: URL, compressCallback: @escaping QjsCompresSuccessCallback , progressCallback: @escaping QjsWatchfaceProgressCallback,finishCallback: @escaping QjsWatchfaceFinishCallback) {
        
        DispatchQueue.global().async { [weak self] in
            WatchfaceSDK.instance.ProgressCallback = progressCallback
            WatchfaceSDK.instance.FinishCallback = finishCallback
            WatchfaceSDK.instance.CompressSuccessCallback = compressCallback
            
            FileUtils.packageQjsMp3(mp3FilePath: musicFilePath) { [weak self] state in
                WatchfaceSDK.instance.CompressSuccessCallback(state)
                if state {
                    self?.pushMusic(devIdentifier: devIdentifier)
                }
            }
         
        }
    }
    
    //开启推送mp3
    func pushMusic(devIdentifier: String) {
        
        self.pushManager.delegate = self
        
        let mp3TmpDir = "output/beinvited.zip"
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let zipFilePath = tempDirectoryURL.appendingPathComponent(mp3TmpDir)
        
        //开启推送
        self.pushManager.pushDialPlate(devIdentifier: devIdentifier, type: 4, zipPath: zipFilePath,withByteAlign: true)
        
    }
    
    //MARK: - Synchronized Custom Dial
    /// - Parameters:
    ///   - devIdentifier: The identifier string of the target device. Through CBPeripheral. Identifier. UuidString acquisition
    ///   - watchface: set SlifiCustomWatchface argument
    ///   - compressSuccessCallback: Compressed file callback
    ///   - progressCallback: Synchronization progress callback
    ///   - finishCallback: Synchronization completes the callback
    @objc public func setCustomWatchface(devIdentifier: String, watchface: SlifiCustomWatchface, compressSuccessCallback: @escaping QjsCompresSuccessCallback, progressCallback: @escaping QjsWatchfaceProgressCallback, finishCallback: @escaping QjsWatchfaceFinishCallback) {
        
        assert(hadInit, "Please call WatchfaceSDK.getInstance().initSDK(application: UIApplication) before using any API")
        
        CompressSuccessCallback = compressSuccessCallback
        ProgressCallback = progressCallback
        FinishCallback = finishCallback
        
        watchface.makeZip { [weak self]zipUrl, error in
            if (error != nil) {
                print("zip compression error:\(String(describing: error))")
                WatchfaceSDK.instance.CompressSuccessCallback(false);
            } else {
                if let zip: URL = zipUrl {
                    WatchfaceSDK.instance.CompressSuccessCallback(true)
                    self?.syncZipFile(devIdentifier: devIdentifier, filePath: zip)
                } else {
                    print("zipUrl is nil")
                    WatchfaceSDK.instance.CompressSuccessCallback(false)

                }
            }
        }

    }
    
    //MARK: - Synchronized Online Dial
    /// - Parameters:
    ///   - devIdentifier: The identifier string of the target device. Through CBPeripheral. Identifier. UuidString acquisition
    ///   - filePath: Online Dial file Path
    ///   - compressSuccessCallback: Compressed file callback
    ///   - progressCallback: Synchronization progress callback
    ///   - finishCallback: Synchronization completes the callback
    @objc public func setOnlineWatchface(devIdentifier: String, filePath: URL, progressCallback: @escaping QjsWatchfaceProgressCallback, finishCallback: @escaping QjsWatchfaceFinishCallback) {
        self.pushManager.delegate = self
        
        assert(hadInit, "Please call WatchfaceSDK.getInstance().initSDK(application: UIApplication) before using any API")
        
        ProgressCallback = progressCallback
        FinishCallback = finishCallback
        
        //开启推送 在线表盘 withByteAlign 传 false
        self.pushManager.pushDialPlate(devIdentifier: devIdentifier, type: 5, zipPath: filePath,withByteAlign: false)
    }
    
    
    private func syncZipFile(devIdentifier: String, filePath: URL) {
        self.pushManager.delegate = self
        //开启推送
        self.pushManager.pushDialPlate(devIdentifier: devIdentifier, type: 5, zipPath: filePath,withByteAlign: true)
    }
    
    /// Abort task。
    @objc public func stop() {
        assert(hadInit, "Please call WatchfaceSDK.getInstance().initSDK(application: UIApplication) before using any API")
        self.pushManager.stop()
    }
}


extension WatchfaceSDK: SFDialPlateManagerDelegate {
    //思澈表盘推送代理回调
    public func dialPlateManager(manager: SFDialPlateSDK.SFDialPlateManager, didUpdateBLEState bleState: SFDialPlateSDK.DPBleCoreManagerState) {
        print("蓝牙状态改变:\(bleState.rawValue)")
    }
    
    public func dialPlateManager(manager: SFDialPlateSDK.SFDialPlateManager, progress: Int) {
        print("推送进度:\(progress)%")
        WatchfaceSDK.instance.ProgressCallback(progress)
    }
    
    public func dialPlateManager(manager: SFDialPlateSDK.SFDialPlateManager, complete error: SFDialPlateSDK.SFError?) {
//        self.isOtaWatchfaceing = false
        if let err = error {
            print("推送失败:\(err)")
            let errInfo: String = err.errInfo
            
            WatchfaceSDK.instance.FinishCallback(false,errInfo,err.errType.rawValue,error?.devErrorCode ?? NSNumber(value: 0))
            return
        }
        WatchfaceSDK.instance.FinishCallback(true,"",0,error?.devErrorCode ?? NSNumber(value: 0))
        print("推送成功")
    }
}