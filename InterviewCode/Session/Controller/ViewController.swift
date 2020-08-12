//
//  XAOEventListController.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import UIKit
import SnapKit
class ViewController: UIViewController, ConstraintRelatableTarget{
    
    struct Key {
        struct Identity {//cell相关的注册
            static let headerIdentity = "header"
            static let footerIdentity = "footer"
            static let cellIdentity   = "cell"
            
        }
        struct cellItemSize {//每组cell items的size.width
            static var cellSecondWidth   = 375
            static let cellFirstWidth    = (375 - 5*3 - 3*4)/4
            static let cellThirdWidth     = (375 - 5*2 - 3*6)/3
        }
    }
    var collecV:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "三"
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        layout.headerReferenceSize = CGSize(width: self.view.bounds.size.width, height: 2)
        layout.footerReferenceSize = CGSize(width: self.view.bounds.size.width, height: 2)
        
        self.collecV = UICollectionView.init(frame: CGRect.null, collectionViewLayout: layout)
        self.collecV.backgroundColor = UIColor.white
        //注册
        self.collecV.register(ItemCell.self, forCellWithReuseIdentifier: "ItemCell")
        self.collecV.register(PercentCell.self, forCellWithReuseIdentifier: "PercentCell")
        self.collecV.register(CarouselCell.self, forCellWithReuseIdentifier: "CarouselCell")
        self.collecV.register(HotDateCell
            .self, forCellWithReuseIdentifier: "HotDateCell")
        collecV.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Key.Identity.headerIdentity);
        collecV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Key.Identity.footerIdentity)
        self.collecV.delegate = self
        self.collecV.dataSource = self
        self.view.addSubview(self.collecV)
        self.collecV.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
    }
    
}

extension ViewController:UICollectionViewDelegateFlowLayout{
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //每组item大小
        if indexPath.section == 0 {
            return CGSize(width: Key.cellItemSize.cellFirstWidth, height: 90)
        }else if indexPath.section == 2 {
            return CGSize(width:Key.cellItemSize.cellThirdWidth, height: 150)
        }else{
            return CGSize(width: Key.cellItemSize.cellSecondWidth, height: 120)
        }
    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //
    //        //行间距
    //    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //
    //        //item之间的距离
    //    }
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 2 {
            return  CGSize(width:Key.cellItemSize.cellThirdWidth, height: 30)
        }else{
            return  CGSize(width:0, height: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        //尾部试图大小
        return  CGSize(width:0, height: 0)
    }
    
}
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }else if section == 1{
            return 1
        }else if section == 2{
            return 3
        }else{
            return 4
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
            //                let data = dataSource[indexPath.row]
            //                cell.imageView.image = #imageLiteral(resourceName: "img");
            cell.titleLabel.text = "name"
            cell.loadData()
            return cell
            
        }else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
            cell.loadData()
            return cell
        }else if indexPath.section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PercentCell", for: indexPath) as! PercentCell
            cell.loadData()
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotDateCell", for: indexPath) as! HotDateCell
            cell.loadData()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader{
            let headerView : HeaderCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Key.Identity.headerIdentity, for: indexPath) as! HeaderCollectionReusableView
            headerView.titleLabel.text = "Recommend"
            headerView.moreBtn.setTitle("More", for: .normal)
            return headerView
        }else{
            let footView : UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Key.Identity.footerIdentity, for: indexPath)
            footView.backgroundColor = UIColor.purple
            return footView
        }
    }
}




//import UIKit
//
//class XAOEventListController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource ,UITableViewDelegate, UITableViewDataSource{
//    var collectionView: UICollectionView!
//    var eventListViewModel =  XAOEventListViewModel()
//    var dataSource = [
//        ["name":"地址管理","pic":"IQH_mine_address"],
//        ["name":"我的收藏","pic":"IQH_mine_myCollection"],
//        ["name":"账号信息","pic":"IQH_mine_accountInformation"],
//        ["name":"系统设置","pic":"IQH_mine_systemSetting"]
//    ]
//    fileprivate lazy var tableView : UITableView = {
//        let tableview = UITableView()
//        tableview.delegate = self
//        tableview.dataSource = self
//        tableview.tableFooterView = UIView()
//        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
//        tableview.showsVerticalScrollIndicator = false
//        self.view.addSubview(tableview)
//        tableview.snp.makeConstraints({[weak self] (make) in
//            guard let strongSelf = self else {
//                return
//            }
//            make.left.right.bottom.equalTo(strongSelf.view)
//            make.top.equalTo(strongSelf.collectionView.snp.bottom)
//
//        })
//        return tableview
//    }()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        /// 设置UI
//        setupUI()
//        eventListViewModel.refresh { [weak self] (status, message) in
//            guard let strongSelf = self else {
//                return
//            }
//            if status == .success {
//                strongSelf.collectionView.reloadData()
//            } else  if status == .noData {
//                strongSelf.collectionView.reloadData()
//            } else {
//            }
//        }
//    }
//    /// 设置UI
//    func setupUI()
//    {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 55
//        layout.minimumInteritemSpacing = 2
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
//        layout.headerReferenceSize = CGSize(width: self.view.bounds.size.width, height: 80)
//        // layout.footerReferenceSize = CGSize(width: self.view.bounds.size.width, height: 80)
//        // layout.itemSize = CGSize(width: (self.view.bounds.size.width - 40) / 4, height: (self.view.bounds.size.width - 40) / 4 + 30)
//        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 500), collectionViewLayout: layout)
//        collectionView.register(XAOHomeBannerCell.self, forCellWithReuseIdentifier: "XAOHomeBannerCell")
//        collectionView.register(MiddleCollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
//        collectionView.register(CarouselViewCell.self, forCellWithReuseIdentifier: "CarouselViewCell")
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.backgroundColor = UIColor.white
//        view.addSubview(collectionView)
//        tableView.tableFooterView = UIView()
//        tableView.register(XAOEventListCellTableViewCell.self, forCellReuseIdentifier: "XAOEventListCellRI")
//    }
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 3
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0{
//            return 4
//        }else if section == 2{
//            return 3
//        }else{
//            return 1
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if indexPath.section == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "XAOHomeBannerCell", for: indexPath) as! XAOHomeBannerCell
//            let data = dataSource[indexPath.row]
//            cell.imageView.image = #imageLiteral(resourceName: "img");
//            cell.titleLabel.text = data["name"] ?? ""
//            cell.loadData()
//            return cell
//
//        }else if indexPath.section == 1 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselViewCell", for: indexPath) as! CarouselViewCell
//            cell.loadData()
//            return cell
//        }else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! MiddleCollectionViewCell
//            cell.loadData()
//            return cell
//        }
//
//    }
//    public func collectionView(_ collectionView: UICollectionView,
//                               layout collectionViewLayout: UICollectionViewLayout,
//                               sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.section == 0{
//            return CGSize(width: (self.view.bounds.size.width - 40) / 4, height: (self.view.bounds.size.width - 40) / 4 + 30)
//        }else if indexPath.section == 2 {
//            return CGSize(width: (self.view.bounds.size.width - 40) / 3, height: (self.view.bounds.size.width - 40) / 3 + 30)
//        }else{
//            return CGSize.init(width: self.view.frame.size.width, height: 600)
//        }
//    }
//    public func collectionView(_ collectionView: UICollectionView,
//                               layout collectionViewLayout: UICollectionViewLayout,
//                               insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
//    }
//
//    public func collectionView(_ collectionView: UICollectionView,
//                               layout collectionViewLayout: UICollectionViewLayout,
//                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 30
//    }
//
//    public func collectionView(_ collectionView: UICollectionView,
//                               layout collectionViewLayout: UICollectionViewLayout,
//                               minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
//    // MARK: - Table view data source
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier:"XAOEventListCellRI", for: indexPath) as! XAOEventListCellTableViewCell
//        cell.loadData(eventListViewModel, indexPath)
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //        tableView.deselectRow(at: indexPath, animated: true)
//        //        let controller = XAOEventDetailsController(model: eventListViewModel.getModel(indexPath.item), curtype: officialDocumentType)
//        //        controller.setDatas(eventListViewModel, indexPath.item, "send")
//        //        navigationController?.pushViewController(controller, animated: true)
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//}

//class XAOEventListController: UIViewController,UITableViewDelegate, UITableViewDataSource {
//    var eventListViewModel =  XAOEventListViewModel()
//    fileprivate lazy var tableView : UITableView = {
//        let tableview = UITableView()
//        tableview.delegate = self
//        tableview.dataSource = self
//        tableview.tableFooterView = UIView()
//        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
//        tableview.showsVerticalScrollIndicator = false
//        self.view.addSubview(tableview)
//        tableview.snp.makeConstraints({[weak self] (make) in
//            guard let strongSelf = self else {
//                return
//            }
//            make.left.right.top.bottom.equalTo(strongSelf.view)
//        })
//        return tableview
//    }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.tableFooterView = UIView()
//        tableView.register(XAOEventListCellTableViewCell.self, forCellReuseIdentifier: XAOEventListCellRI)
//
//        eventListViewModel.refresh { [weak self] (status, message) in
//            guard let strongSelf = self else {
//                return
//            }
//            if status == .success {
//                strongSelf.tableView.reloadData()
//            } else  if status == .noData {
//                strongSelf.tableView.reloadData()
//            } else {
//            }
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//    // MARK: - Table view data source
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier:XAOEventListCellRI, for: indexPath) as! XAOEventListCellTableViewCell
//        cell.loadData(eventListViewModel, indexPath)
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //        tableView.deselectRow(at: indexPath, animated: true)
//        //        let controller = XAOEventDetailsController(model: eventListViewModel.getModel(indexPath.item), curtype: officialDocumentType)
//        //        controller.setDatas(eventListViewModel, indexPath.item, "send")
//        //        navigationController?.pushViewController(controller, animated: true)
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}
