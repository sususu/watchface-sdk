//
//  HWFeatureViewController.swift
//  HuaWo_iOS_SDKDemo
//
//  Created by huawo01 on 2024/8/1.
//

import UIKit

class HWFeatureViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let features = ["Custom Dial", "Online Dial", "Sync Album", "Sync Music", "OTA Update"]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FeatureCell.self, forCellWithReuseIdentifier: "FeatureCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feature"
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCell", for: indexPath) as! FeatureCell
        cell.configure(with: features[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let vc: HWCustomDialViewController = HWCustomDialViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc: HWOnlineDialViewController = HWOnlineDialViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let vc: HWAlbumViewController = HWAlbumViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let vc: HWMusicViewController = HWMusicViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
            let vc: HWOTAUpdateViewController = HWOTAUpdateViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 30
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
}

class FeatureCell: UICollectionViewCell {
    
    private let featureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(featureLabel)
        featureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            featureLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            featureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            featureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            featureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with feature: String) {
        featureLabel.text = feature
    }
}
