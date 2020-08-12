//
//  XAOEventListCellTableViewCell.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import UIKit
import SnapKit
class HotDateCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.width.equalTo(200)
        })
        return titleLabel
    }()
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        addSubview(imgView)
        imgView.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.right.equalTo(strongSelf).offset(-10)
            make.top.equalTo(strongSelf.titleLabel)
            make.width.equalTo(60)
            make.height.equalTo(60)
        })
        return imgView
    }()
    lazy var hotLabel: UILabel = {
        let hotLabel = UILabel()
        hotLabel.font = UIFont.systemFont(ofSize: 10)
        hotLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        hotLabel.textAlignment = .left
        hotLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hotLabel)
        hotLabel.snp.makeConstraints({ [weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.equalTo(strongSelf.titleLabel)
            make.bottom.equalTo(strongSelf.imgView)
        })
        return hotLabel
    }()
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        dateLabel.textAlignment = .right
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints({ [weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.right.equalTo(strongSelf.imgView.snp.left).offset(-10)
            make.bottom.equalTo(strongSelf.hotLabel)
        })
        return dateLabel
    }()
    //    func loadData(_ viewModel: XAOEventListViewModel, _ indexPath: IndexPath) {
    //        titleLabel.text = "The impact of the Civil Code on our lives"
    //        imgView.isHidden = false
    //        hotLabel.text = "Hot topic"
    //        dateLabel.text = "time"
    //
    //    }
    func loadData() {
        titleLabel.text = "The impact of the Civil Code on our lives"
        imgView.isHidden = false
        hotLabel.text = "Hot topic"
        dateLabel.text = "time"
        
    }
}
