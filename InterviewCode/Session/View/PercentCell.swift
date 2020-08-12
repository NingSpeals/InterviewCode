//
//  MiddleCollectionViewCell.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import UIKit
import SnapKit

class PercentCell: UICollectionViewCell {
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.top.equalTo(strongSelf).offset(20)
            make.centerX.equalTo(strongSelf)
            make.left.right.equalTo(strongSelf)
            
        })
        return titleLabel
    }()
    lazy var percentLabel : UILabel = {
        let percentLabel = UILabel()
        percentLabel.textAlignment = .center
        percentLabel.font = UIFont.boldSystemFont(ofSize: 20)
        percentLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        addSubview(percentLabel)
        percentLabel.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.top.equalTo(strongSelf.titleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(strongSelf.titleLabel)
            
        })
        return percentLabel
    }()
    
    lazy var yearLabel : UILabel = {
        let yearLabel = UILabel()
        yearLabel.numberOfLines = 2
        yearLabel.textAlignment = .center
        yearLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        yearLabel.font = UIFont.systemFont(ofSize: 13)
        addSubview(yearLabel)
        yearLabel.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.top.equalTo(strongSelf.percentLabel.snp.bottom).offset(10)
            make.left.right.equalTo(strongSelf.percentLabel)
            
        })
        return yearLabel
    }()
    lazy var btn : UILabel = {
        let btn = UILabel()
        btn.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        btn.textAlignment = .center
        btn.font = UIFont.systemFont(ofSize: 13)
        addSubview(btn)
        btn.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.top.equalTo(strongSelf.yearLabel.snp.bottom).offset(10)
            make.left.right.equalTo(strongSelf.yearLabel)
            
        })
        return btn
    }()
//    var titleLabel: UILabel!
//    var percentLabel: UILabel!
//    var yearLabel: UILabel!
//    var btn: UILabel!
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        titleLabel = UILabel()
//        titleLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 20)
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont.systemFont(ofSize: 17)
//        percentLabel = UILabel(frame: CGRect(x: 0, y: titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, width: self.bounds.size.width, height: 20))
//        percentLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//        percentLabel.textAlignment = .center
//        percentLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        yearLabel = UILabel(frame: CGRect(x: 0, y: percentLabel.frame.origin.y + percentLabel.frame.size.height + 10, width: self.bounds.size.width, height: 40))
//        yearLabel.numberOfLines = 2
//        yearLabel.textAlignment = .center
//        yearLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        yearLabel.font = UIFont.systemFont(ofSize: 13)
//        btn = UILabel(frame: CGRect(x: 0, y: yearLabel.frame.origin.y + yearLabel.frame.size.height + 10, width: self.bounds.size.width, height: 20))
//        btn.textAlignment = .center
//        btn.font = UIFont.systemFont(ofSize: 13)
//        addSubview(titleLabel)
//        addSubview(percentLabel)
//        addSubview(yearLabel)
//        addSubview(btn)
//
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    func loadData() {
        titleLabel.text = "Fund"
        percentLabel.text = "5.17%"
        yearLabel.text = "Gains in the past year"
        btn.text = "Buy"
    }
}
