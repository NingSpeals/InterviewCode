//
//  XAOEventListViewModel.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import UIKit

class XAOEventListViewModel: WSNViewModel {
    override func load(_ loadType: WSNViewModelLoadType,
                       _ completionHandler: @escaping WSNViewModelCompletionHandler) {
        super.load(loadType, completionHandler)
        session.parameters["curtype"] = ""
        session.load(XAONetManager.loadData(session.parameters) { [weak self] (result) in
            
            guard let strongSelf = self else {
                completionHandler(.fail, "异常,数据对象被释放")
                return
            }
            strongSelf.session.isLoading = false
//            if let model = result.model as? WSNListBaseModel {
//                if loadType == .refresh {
//                    strongSelf.session.datas.removeAll()
//                }
//                if let list = model.items,
//                    list.count > 0 {
//                    strongSelf.session.datas.append(contentsOf: list)
//                    completionHandler(.success, model.msg ?? "")
//                } else {
//                    completionHandler(.noData, "没有数据")
//                }
//            } else {
//                completionHandler(.fail, result.message)
//            }
        })
    }
    func getModel(_ item: Int) -> WSNListModel {
        return session.datas[item] as! WSNListModel
    }
    func getEventId(_ item: Int) -> String? {
        return getModel(item).eventId?.description
    }
    func getTitle(_ item: Int) -> String? {
        return getModel(item).title
    }
    func getRealName(_ item: Int) -> String? {
        return getModel(item).realName
    }
    func getNodeDesc(_ item: Int) -> String? {
        return getModel(item).nodeDesc
    }
    func getTimeLimit(_ item: Int) -> String? {
        return getModel(item).timeLimit
    }
    func getIsLimit(_ item: Int) -> String? {
        return getModel(item).isLimit
    }
    func getDateNodeCreated(_ item: Int) -> String? {
        return getModel(item).dateNodeCreated
    }
    func getsActorId(_ item: Int) -> String? {
        return getModel(item).actorId?.description
    }
    func getDateCreated(_ item: Int) -> String? {
        return getModel(item).dateCreated
    }
    func getWorkdays(_ item: Int) -> String? {
        return getModel(item).workdays?.description
    }
}

