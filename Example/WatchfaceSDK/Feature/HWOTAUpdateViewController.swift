//
//  HWOTAUpdateViewController.swift
//  WatchfaceSDK_Example
//
//  Created by huawo01 on 2024/8/16.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SnapKit
import HwBluetoothSDK
import WatchfaceSDK
import SSZipArchive

class HWOTAUpdateViewController: UIViewController {
    
    private let syncOnlineDialButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("OTA Update", for: .normal)
        button.addTarget(self, action: #selector(OTAUpdate), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Online Dial"
        self.view.backgroundColor = .white
        
        self.view.addSubview(syncOnlineDialButton)
        syncOnlineDialButton.snp.makeConstraints { make in
            make.top.equalTo(260)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func OTAUpdate() {
        
        // Please extract the firmware update zip provided to you to get the firmware packages and difference packages
        // firmwarePath: Please pass in the firmware package path
        // differencePath: Please pass in the differential resource path
        guard let zipPath = scZipPath(handleZipFile: Bundle.main.path(forResource: "HS02_KW266_TA_from_V1.0.6B66_To_V1.0.6B67", ofType: "zip")!) else { return }
        guard let subDirs = QjsStorageUtils.getFiles(atDirectory: zipPath) else { return }
        var firmwarePath: String?
        var differencePath: String?

        for fp in subDirs {
            let name = (fp as NSString).lastPathComponent
            let path = (zipPath as NSString).appendingPathComponent(fp)
            
            if name.hasSuffix("diff.zip") {
                differencePath = path
            } else if name.hasSuffix(".zip") && name.hasPrefix("HS02_KW266_TA") {
                firmwarePath = path
            }
        }

        print("firmwarePath = \(String(describing: firmwarePath))")
        print("differencePath = \(String(describing: differencePath))")
        if let device:HwBluetoothDevice = HwBluetoothCenter.sharedInstance().connectedDevice {
            HwOTAUpdateManager.shared.startFirmwareUpgrade(devIdentifier: device.peripheral.identifier.uuidString, firmwarePath: firmwarePath!, differencePath: differencePath!) { state, progress, errorType, errorDes in
                switch state {
                case .progress:
                    print("FirmwareUpdateStateProgress : \(progress)")
                case .success:
                    print("FirmwareUpdateStateSuccess")
                case .failure:
                    print("FirmwareUpdateStateFailure, errorType = \(errorType), errorDes = \(errorDes)")
                }
            }
        }

    }
    
    func scZipPath(handleZipFile zipFilePath: String) -> String? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd_HH_mm_ss"
        let unzipPath = (QjsStorageUtils.getTempPath() as NSString).appendingPathComponent("TA/\(df.string(from: Date()))")
        if !QjsStorageUtils.isFileExits(atPath: unzipPath) {
            QjsStorageUtils.createPath(path: unzipPath)
        } else {
            QjsStorageUtils.deleteFiles(atPath: unzipPath)
        }
        
        let result = SSZipArchive.unzipFile(atPath: zipFilePath, toDestination: unzipPath)
        if !result {
            print("Failed to decompress the file. There may be an error downloading the file. Please re-download")
            return nil
        }
        
        guard let subDirs = QjsStorageUtils.getFiles(atDirectory: unzipPath) else {
            print("ZIP is empty after decompression")
            return nil
        }
        
        return unzipPath
    }
}
