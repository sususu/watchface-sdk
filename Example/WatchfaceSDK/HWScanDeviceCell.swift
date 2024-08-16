//
//  HWScanDeviceCell.swift
//  WatchfaceSDK_Example
//
//  Created by huawo01 on 2024/8/8.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

class HWScanDeviceCell: UITableViewCell, Reusable {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        titleLabel.textColor = UIColor.black
        titleLabel.text = "name"
        return titleLabel
    }()
    
    lazy var macLabel: UILabel = {
        let macLabel = UILabel()
        macLabel.textAlignment = .left
        macLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        macLabel.textColor = UIColor.black
        macLabel.text = "mac"
        return macLabel
    }()
        
    func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(5)
            make.leading.equalTo(self.contentView).offset(16)
        }
        
        addSubview(macLabel)
        macLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(self.contentView).offset(16)
        }
    }
}
