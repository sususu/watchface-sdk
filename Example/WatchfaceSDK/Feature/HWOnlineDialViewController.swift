//
//  HWOnlineDialViewController.swift
//  HuaWo_iOS_SDKDemo
//
//  Created by huawo01 on 2024/8/1.
//

import UIKit
import SnapKit
import HwBluetoothSDK
import WatchfaceSDK

class HWOnlineDialViewController: UIViewController {
    
    private let syncOnlineDialButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sync Online Dial", for: .normal)
        button.addTarget(self, action: #selector(syncOnlineDial), for: .touchUpInside)
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
    
    @objc private func syncOnlineDial() {
        
        if let zipFilePath = Bundle.main.path(forResource: "JW_HS01WF005", ofType: "zip") {
            
            let zipFileURL = URL(fileURLWithPath: zipFilePath)
            
            if let device:HwBluetoothDevice = HwBluetoothCenter.sharedInstance().connectedDevice {
                
                SifliWatchfaceSDK.getInstance().setOnlineWatchface(devIdentifier: device.peripheral.identifier.uuidString, filePath: zipFileURL) { progress in
                    
                    print("progress: \(progress)")
                    
                } finishCallback: { isFinish, info, errorType, errorCode in
                    
                    if isFinish {
                        print("syncDial success")
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
}
