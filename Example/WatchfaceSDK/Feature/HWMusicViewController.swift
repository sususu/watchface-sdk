//
//  HWMusicViewController.swift
//  WatchfaceSDK_Example
//
//  Created by huawo01 on 2024/8/9.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit
import HwBluetoothSDK
import WatchfaceSDK

class HWMusicViewController: UIViewController {
    
    private let syncOnlineDialButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sync Music", for: .normal)
        button.addTarget(self, action: #selector(syncMusic), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sync Music"
        self.view.backgroundColor = .white
        
        self.view.addSubview(syncOnlineDialButton)
        syncOnlineDialButton.snp.makeConstraints { make in
            make.top.equalTo(260)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func syncMusic() {
        
        // Get the doc directory path
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]

        // Create a music/mp3 subdirectory
        let musicDirectory = documentsDirectory.appending("/music/mp3")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: musicDirectory) {
            try? fileManager.createDirectory(atPath: musicDirectory, withIntermediateDirectories: true, attributes: nil)
        }

        // Write music files to the music/mp3 subdirectory
        if let music1Path = Bundle.main.path(forResource: "Ranganayaki", ofType: "mp3"),
           let music2Path = Bundle.main.path(forResource: "Sufiyana", ofType: "mp3"),
           let music3Path = Bundle.main.path(forResource: "World Tour", ofType: "mp3") {
            
            let music1Data = try? Data(contentsOf: URL(fileURLWithPath: music1Path))
            let music2Data = try? Data(contentsOf: URL(fileURLWithPath: music2Path))
            let music3Data = try? Data(contentsOf: URL(fileURLWithPath: music3Path))
            
            if let music1Data = music1Data {
                try? music1Data.write(to: URL(fileURLWithPath: musicDirectory.appending("/Ranganayaki.mp3")), options: .atomic)
            }
            
            if let music2Data = music2Data {
                try? music2Data.write(to: URL(fileURLWithPath: musicDirectory.appending("/Sufiyana.mp3")), options: .atomic)
            }
            
            if let music3Data = music2Data {
                try? music3Data.write(to: URL(fileURLWithPath: musicDirectory.appending("/World Tour.mp3")), options: .atomic)
            }
        }
        
        let musicDirectoryURL = URL(string: musicDirectory)!

        if let device:HwBluetoothDevice = HwBluetoothCenter.sharedInstance().connectedDevice {
            SifliWatchfaceSDK.getInstance().setMusicFiles(devIdentifier: device.peripheral.identifier.uuidString, musicFilePath: musicDirectoryURL) { iscompressSuccess in
                if iscompressSuccess {
                    print("Compression success")
                } else {
                    print("Compression failure")
                }
            } progressCallback: { progress in
                print("progress: \(progress)")
            } finishCallback: { isFinish, info, errorType, errorCode  in
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

