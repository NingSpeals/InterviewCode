//
//  XAOHomeBannerCell.swift
//  XiongAnOffice
//
//  Created by 徐玉珊 on 2018/4/18.
//  Copyright © 2018年 chinatelecom. All rights reserved.
//

import UIKit
import SnapKit

class ItemCell: UICollectionViewCell {
    lazy var imgView : UIImageView = {
        let imgView = UIImageView()
        addSubview(imgView)
        imgView.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.centerX.equalTo(strongSelf)
            make.width.height.equalTo(60)
        })
        return imgView
    }()
    
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.bottom.equalTo(strongSelf)
            make.left.right.equalTo(strongSelf)
            
        })
        return titleLabel
    }()
    func loadData() {
        imgView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        titleLabel.text = "dsdsdf"
    }
}

