//
//  HeaderCollectionReusableView.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/20.
//  Copyright © 2020 Ning. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.text = "Recommend"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.bottom.top.equalTo(strongSelf)
            make.right.equalTo(strongSelf)
            make.left.equalTo(strongSelf).offset(20)
            
        })
        return titleLabel
    }()
    
    lazy var moreBtn: UIButton = {
        let moreBtn = UIButton(type: .custom)
        moreBtn.setTitle("More", for: .normal)
        moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        moreBtn.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(moreBtn)
        moreBtn.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.right.equalTo(strongSelf).offset(-8)
            make.top.equalTo(strongSelf)
            make.height.equalTo(48)
            make.width.equalTo(100)
        }
        return moreBtn
    }()
}
