//
//  HWAlbumViewController.swift
//  WatchfaceSDK_Example
//
//  Created by huawo01 on 2024/8/9.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit
import HwBluetoothSDK
import WatchfaceSDK

class HWAlbumViewController: UIViewController {
    
    private let syncOnlineDialButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sync Album", for: .normal)
        button.addTarget(self, action: #selector(syncAlbum), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sync Album"
        self.view.backgroundColor = .white
        
        self.view.addSubview(syncOnlineDialButton)
        syncOnlineDialButton.snp.makeConstraints { make in
            make.top.equalTo(260)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func syncAlbum() {
        let album1 = QjsAlbumModel()
        album1.image = UIImage(named: "IMG_4611")
        album1.name = "1"
        
        let album2 = QjsAlbumModel()
        album2.image = UIImage(named: "IMG_4585")
        album2.name = "2"
        
        let albums = [album1,album2]
        SifliWatchfaceSDK.getInstance().width = 480.0
        SifliWatchfaceSDK.getInstance().height = 480.0
        
        
        if let device:HwBluetoothDevice = HwBluetoothCenter.sharedInstance().connectedDevice {
            
            SifliWatchfaceSDK.getInstance().setPictures(devIdentifier: device.peripheral.identifier.uuidString, compressSuccessCallback: { iscompressSuccess in
                if iscompressSuccess {
                    print("Compression success")
                } else {
                    print("Compression failure")
                }
            }, albums: albums) { progress in
                print("progress: \(progress)")
            } finishCallback: { isFinish, info, errorType, errorCode in
                if isFinish {
                    print("syncPictures success")
                } else {
                    if errorCode == 37 || errorType == 16 {
                        print("There is not enough storage space for the watch. Please remove other watchfaces and try again")
                    } else if errorType == 4 || errorType == 1 || errorCode == 6 || errorCode == 38 {
                        print("Bluetooth disconnection or sync timeout, please keep your phone close to the watch")
                    } else {
                        print("syncDial failure")
                    }
                }
            }
            
        }

    }
}
