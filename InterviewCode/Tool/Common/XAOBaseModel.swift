//
//  XAOBaseModel.swift
//  XiongAnOffice
//
//  Created by 徐玉珊 on 2018/4/12.
//  Copyright © 2018年 chinatelecom. All rights reserved.
//

import Foundation

@objcMembers class XAOBaseModel: WSNModel {
    /// 数据状态：0-正常,1-异常
    var stat: String? = "1"
    /// 附加信息
    var msg: String? = "数据请求失败"
    /// 因为数据接口有个新加字段，这是可以变化的字符串
    var kebian: String? = "数据请求失败"
    /// 数据字典模型集合
    var items: [Any]?
    /// 数据字典模型
    var item: Any?
    /// 数据字典模型
    var result: Any?
    /// 数据字典模型集合
    var countys: [Any]?
    
    /// 判断数据是否正常
    var isNoError: Bool {
        if let status = stat,
            status == "0" {
            return true
        }
        return false
    }

    override open class func specialClassTypes() -> Dictionary<String, String> {
        return ["item" : "CLCModel",
                "items": "CLCModel",
                "result": "CLCModel"]
    }
}
