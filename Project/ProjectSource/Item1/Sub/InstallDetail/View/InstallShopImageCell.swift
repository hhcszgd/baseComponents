//
//  InstallShopImageCell.swift
//  Project
//
//  Created by 张凯强 on 2018/1/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class InstallShopImageCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "ShopImageCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ShopImageCell")
        self.flowLayout.minimumLineSpacing = 20
        self.flowLayout.minimumInteritemSpacing = 20
        self.flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.isPagingEnabled = true
        self.selectionStyle = .none
        // Initialization code
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return
            self.dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ShopImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopImageCell", for: indexPath) as! ShopImageCell
        cell.backgroundColor = UIColor.white
        cell.model = self.dataArr[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: SCREENWIDTH / 2.0, height: self.collectionView.bounds.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var arr: [GDIBPhoto] = []
        for model in self.dataArr {
            let photo: GDIBPhoto = GDIBPhoto(dict: nil)
            photo.imageURL = model.image
            arr.append(photo)
            
        }
        let view = GDIBContentView.init(photos: arr, showingPage: indexPath.item)
    }
   
    var dataArr: [ShopImagesModel] = []{
        didSet{
            self.collectionView.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
