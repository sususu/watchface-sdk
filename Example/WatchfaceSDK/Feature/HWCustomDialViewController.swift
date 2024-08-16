//
//  HWCustomDialViewController.swift
//  HuaWo_iOS_SDKDemo
//
//  Created by huawo01 on 2024/8/1.
//

import UIKit
import SnapKit
import RSColorPicker
import HwBluetoothSDK
import WatchfaceSDK
import SDWebImage

class HWCustomDialViewController: UIViewController, UINavigationControllerDelegate {
    
    private let timeImageView: UIImageView = {
        let timeImageView = UIImageView()
        timeImageView.image = UIImage(named: "icon_watchface_edit_time_style1")
        return timeImageView
    }()
        
    private let dialBackground: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 130 // Half of 466
        view.layer.masksToBounds = true
        return view
    }()
    
    private let switchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose Watch Size", for: .normal)
        button.addTarget(self, action: #selector(showCircleOptions), for: .touchUpInside)
        return button
    }()
    
    private let timeColorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose Time Color", for: .normal)
        button.addTarget(self, action: #selector(showTimeColorPicker), for: .touchUpInside)
        return button
    }()
    
    private let dialBgColorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose Dial bgColor", for: .normal)
        button.addTarget(self, action: #selector(showDialColorPicker), for: .touchUpInside)
        return button
    }()
    
    private let selectAlbumButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose Album Dial Bg", for: .normal)
        button.addTarget(self, action: #selector(selectAlbum), for: .touchUpInside)
        return button
    }()
    
    private let selectGifButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose gif Dial Bg", for: .normal)
        button.addTarget(self, action: #selector(selectGif), for: .touchUpInside)
        return button
    }()
    
    private let syncDialButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sync Dial", for: .normal)
        button.addTarget(self, action: #selector(syncDial), for: .touchUpInside)
        return button
    }()
    
    private var colorPicker: RSColorPickerView?
    private var doneButton: UIButton?
    private var isTime: Bool = false
    
    //The default is 466*466
    private var width = 466
    private var height = 466
    
    private var gifURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CustomDial"
        self.view.backgroundColor = .white
 
        self.view.addSubview(dialBackground)
        self.view.addSubview(switchButton)
        self.view.addSubview(timeColorButton)
        self.view.addSubview(dialBgColorButton)
        self.view.addSubview(selectAlbumButton)
        self.view.addSubview(selectGifButton)
        dialBackground.addSubview(timeImageView)
        self.view.addSubview(syncDialButton)
             
        dialBackground.snp.makeConstraints { make in
            make.width.height.equalTo(260)
            make.top.equalTo(150)
            make.centerX.equalToSuperview()
        }
        
        timeImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dialBackground.snp.top).offset(30)
        }
        
        switchButton.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        timeColorButton.snp.makeConstraints { make in
            make.top.equalTo(dialBackground.snp.bottom).offset(30)
            make.leading.equalTo(20)
        }
        
        dialBgColorButton.snp.makeConstraints { make in
            make.top.equalTo(dialBackground.snp.bottom).offset(30)
            make.trailing.equalTo(-20)
        }
        
        selectAlbumButton.snp.makeConstraints { make in
            make.top.equalTo(dialBackground.snp.bottom).offset(60)
            make.leading.equalTo(20)
        }
        
        selectGifButton.snp.makeConstraints { make in
            make.top.equalTo(dialBackground.snp.bottom).offset(60)
            make.trailing.equalTo(-20)
        }
        
        syncDialButton.snp.makeConstraints { make in
            make.top.equalTo(selectAlbumButton.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
        }
    }
        
    @objc private func showCircleOptions() {
        let alertController = UIAlertController(title: "Choose Circle Size", message: nil, preferredStyle: .actionSheet)
        
        let smallCircleAction = UIAlertAction(title: "466x466", style: .default) { _ in
            self.switchCircle(toLarge: false)
        }
        
        let largeCircleAction = UIAlertAction(title: "480x480", style: .default) { _ in
            self.switchCircle(toLarge: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(smallCircleAction)
        alertController.addAction(largeCircleAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func showDialColorPicker() {
        showColorPicker(false)
    }
    
    @objc private func showTimeColorPicker() {
        showColorPicker(true)
    }
    
    @objc private func selectAlbum() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.sourceType = .photoLibrary
//        present(imagePickerController, animated: true, completion: nil)
        dialBackground.image = UIImage(named: "IMG_4627");
    }
    
    @objc private func selectGif() {
        if let gifFilePath = Bundle.main.path(forResource: "FD722AA7", ofType: "gif") {
            gifURL = URL(fileURLWithPath: gifFilePath)
            dialBackground.sd_setImage(with: gifURL, placeholderImage: nil)
        }
    }
    
    @objc private func syncDial() {

        guard let thumbnail = dialBackground.asImage() else {
            return
        }
        
        
        let watchface = SlifiCustomWatchface(width: width, height: height)
        
        if let gifURL = self.gifURL {
            watchface.backgroundGif = gifURL
        } else {
            if let bgImg = dialBackground.image {
                watchface.backgroundImage = bgImg.resize(CGSize(width: width, height: height), cornerRadius: CGFloat(width / 2));
            }
        }
        watchface.thumbnailImage = thumbnail.resize(CGSize(width: 264, height: 264), cornerRadius: 132)
        
        let color = timeImageView.tintColor ?? UIColor.white
        
        let time = Time(tintColor: color)
        time.x = (width - time.width) / 2
        time.y = 60
        time.id = 0
        watchface.widgetList.append(time)
        
        let date = Date(tintColor: color)
        date.x = 150
        date.y = 200
        date.valueType = QjsValueType.dateNum.rawValue
        date.name = "date"
        date.id = 2
        watchface.widgetList.append(date)
        
        let week = Week(tintColor: color)
        week.x = 220
        week.y = 200
        week.valueType = QjsValueType.weekData.rawValue
        week.name = "week"
        week.id = 3
        watchface.widgetList.append(week)
        
        
        if let device:HwBluetoothDevice = HwBluetoothCenter.sharedInstance().connectedDevice {
            WatchfaceSDK.getInstance().setCustomWatchface(devIdentifier: device.peripheral.identifier.uuidString, watchface: watchface) { iscompressSuccess in
                if iscompressSuccess {
                    print("Compression success")
                } else {
                    print("Compression failure")
                }
            } progressCallback: { progress in
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

        } else {
            print("connectedDevice failure")
        }
        
    }
    
    func showColorPicker( _ isTime :Bool) {
        self.isTime = isTime
        colorPicker = RSColorPickerView(frame: CGRect(x: (self.view.bounds.size.width - 200) / 2.0, y: 430, width: 200, height: 200))
        colorPicker?.selectionColor = .white
        colorPicker?.cropToCircle = true
        colorPicker?.delegate = self
        if let colorPicker = colorPicker {
            view.addSubview(colorPicker)
        }
        
        doneButton = UIButton(type: .system)
        doneButton?.setTitle("Done", for: .normal)
        doneButton?.addTarget(self, action: #selector(dismissColorPicker), for: .touchUpInside)
        if let doneButton = doneButton {
            view.addSubview(doneButton)
            doneButton.snp.makeConstraints { make in
                make.top.equalTo(colorPicker!.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
            }
        }
    }
    
    @objc private func dismissColorPicker() {
        colorPicker?.removeFromSuperview()
        doneButton?.removeFromSuperview()
    }
    
    private func switchCircle(toLarge: Bool) {
        if toLarge {
            width = 480
            height = 480

            dialBackground.layer.cornerRadius = 150
            dialBackground.snp.remakeConstraints { make in
                make.width.height.equalTo(300)
                make.top.equalTo(150)
                make.centerX.equalToSuperview()
            }
        } else {
            width = 466
            height = 466

            dialBackground.layer.cornerRadius = 130
            dialBackground.snp.remakeConstraints { make in
                make.width.height.equalTo(260)
                make.top.equalTo(150)
                make.centerX.equalToSuperview()
            }
        }
    }
}

extension HWCustomDialViewController: RSColorPickerViewDelegate, UIImagePickerControllerDelegate {
    func colorPickerDidChangeSelection(_ colorPicker: RSColorPickerView!) {
        let selectedColor = colorPicker.selectionColor
        if self.isTime {
            timeImageView.tintColor = selectedColor
            timeImageView.image = timeImageView.image?.withRenderingMode(.alwaysTemplate)
        } else {
            dialBackground.image = UIImage.imageWithColor(color: selectedColor!, size: CGSize(width: width, height: height))
        }
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let selectedImage = info[.originalImage] as? UIImage {
//            dialBackground.image = selectedImage
//        }
//        dismiss(animated: true, completion: nil)
//    }

//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
}



