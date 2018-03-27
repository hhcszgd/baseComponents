//
//  SelectAreaViewXib.swift
//  Project
//
//  Created by 张凯强 on 2018/3/16.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class SelectAreaViewXib: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var streetBtn: UIButton!
    @IBOutlet var areaBtn: UIButton!
    @IBOutlet var cityBtn: UIButton!
    @IBOutlet var province: UIButton!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AreaSelectColCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AreaSelectColCell", for: indexPath) as! AreaSelectColCell
        cell.backgroundColor = UIColor.randomColor()
        cell.cellBlock = { [weak self](model) in
            self?.createBtn(model: model)
            
        }
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    func createBtn(model: AreaModel) {
        
    }
    
    @IBOutlet var topView: UIScrollView!
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBAction func sureAction(_ sender: UIButton) {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    ///构造方法
    var type: Int?
    var url: String?
    var containerView: UIView!
    init(frame: CGRect, type: Int, url: String) {
        super.init(frame: frame)
        self.containerView = Bundle.main.loadNibNamed("SelectAreaViewXib", owner: self, options: nil)?.last as! UIView
        self.addSubview(containerView)
        self.collectionView.register(UINib.init(nibName: "AreaSelectColCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AreaSelectColCell")
        self.type = type
        self.url = url
        
        self.requestData(parentid: nil) { (model) in
            if let arr = model?.data {
                self.numberItem = 1
                self.provinceDataArr = arr
            }else {
                self.numberItem = 0
                
            }
            self.collectionView.reloadData()
        }
        
        
    }
    var numberItem: Int = 0
    var provinceDataArr: [AreaModel] = [AreaModel]()
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
        self.flowLayout.itemSize = self.collectionView.bounds.size
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension SelectAreaViewXib {
    ///请求数据
    func requestData(parentid: String?, success: @escaping ((BaseModelForArr<AreaModel>?) -> ())) {
        let token = DDAccount.share.token ?? ""
        let id = DDAccount.share.id ?? ""
        
        var paramete = ["token": token] as [String: Any]
        if self.type != 0 {
            paramete["type"] = self.type ?? 0
        }
        if let fatherid = parentid {
            paramete["parent_id"] = fatherid
        }
        
        var router: Router?
        if url == nil {
            router = Router.get("member/\(id)/shop/area", .api, paramete)
        }else {
            router = Router.get(url!, .api, paramete)
        }
        NetWork.manager.requestData(router: router!).subscribe(onNext: { (dict) in
            let model = BaseModelForArr<AreaModel>.deserialize(from: dict)
            
            success(model)
            
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("完成")
        }) {
            mylog("回收")
        }
    }
    
}


