//
//  ViewController.swift
//  WatchfaceSDK
//
//  Created by HWdan on 08/07/2024.
//  Copyright (c) 2024 HWdan. All rights reserved.
//

import UIKit
import Reusable
import HwBluetoothSDK

class ViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    var dataSource: NSMutableArray = []
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: HWScanDeviceCell.self)
        return tableView
    }()
    
    lazy var scanBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Scan Devices", for: .normal)
        button.addTarget(self, action: #selector(scanDevices), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.addSubview(scanBtn)
        scanBtn.snp.makeConstraints { make in
            make.top.equalTo(150)
            make.centerX.equalToSuperview()
        }
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(scanBtn.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.scanDevices()
        }
    }
    
    @objc private func scanDevices() {
        HwBluetoothSDK.sharedInstance().scan(callback: { [weak self] devices, error in
            if error != nil {
                print("error:\(String(describing: error))")
                return
            }
            
            var existingMacAddresses = Set<String>()
            for device in self?.dataSource as? [HwBluetoothDevice] ?? [] {
                if let macAddress = device.macAddress {
                    existingMacAddresses.insert(macAddress)
                }
            }
            
            for device in devices ?? [] {
                if let macAddress = device.macAddress, !existingMacAddresses.contains(macAddress) {
                    self?.dataSource.add(device)
                    existingMacAddresses.insert(macAddress)
                }
            }
            
            var swiftArray = self?.dataSource as? [HwBluetoothDevice] ?? []
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                swiftArray.sort { (obj1, obj2) -> Bool in
                    if obj1.rssi == nil || obj2.rssi == nil {
                        return false
                    }
                    if obj1.rssi.intValue == obj2.rssi.intValue {
                        return false
                    }
                    return obj1.rssi.intValue > obj2.rssi.intValue
                }
                
                // Convert back to NSMutableArray
                self?.dataSource = NSMutableArray(array: swiftArray)
                self?.tableView.reloadData()
            }
            
        }, stopAfter: 5) {
            
        }
    }
    
    func connectDevice(device: HwBluetoothDevice) {
        HwBluetoothSDK.sharedInstance().connect(with: device, timeout: 15) { error in
            if error == nil {
                print("Connection successful")
                let featureVC = HWFeatureViewController()
                let navigationController = UINavigationController(rootViewController: featureVC)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            } else {
                print("Connection failure")
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: HWScanDeviceCell.self)
        let device:HwBluetoothDevice = self.dataSource[indexPath.row] as! HwBluetoothDevice
        cell.titleLabel.text = device.name
        cell.macLabel.text = device.macAddress
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let device:HwBluetoothDevice = self.dataSource[indexPath.row] as! HwBluetoothDevice
        connectDevice(device: device)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

