//
//  WSNListBaseModel.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import UIKit

@objcMembers class WSNListBaseModel: XAOBaseModel {
    open override class func specialClassTypes() -> Dictionary<String, String> {
        return ["items" : "WSNListModel"]
    }
}
@objcMembers class WSNListModel: XAOBaseModel {
    /// 事项Id
    var eventId: NSNumber?
    /// 标题
    var title: String?
    /// 办理人
    var realName: String?
    /// 流转状态
    var nodeDesc: String?
    /// 办理期限
    var timeLimit: String?
    /// 是否超时
    var isLimit: String?
    /// 收到日期
    var dateNodeCreated: String?
    /// 流程Id
    var actorId: NSNumber?
    /// 创建日期
    var dateCreated: String?
    /// 办理天数
    var workdays: NSNumber?
}
