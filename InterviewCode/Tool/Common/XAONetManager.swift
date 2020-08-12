//
//  XAONetManager.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import Foundation
import UIKit

private let baseURL = "http://192.168.1.124:8181/igrp4api/dispatch.json"
/// 状态类型枚举
public enum CLStatus {
    /// 失败
    case fail
    /// 成功
    case success
}
public typealias XAONetDownloadCompletionHandler = (_ locationURL: URL?, _ status: CLStatus) -> Void
/// 网络请求统一管理中心
class XAONetManager {
    /// HTTP数据POST请求
    @discardableResult
    static func post(_ requestKey: String,
                     _ fields: [String : String],
                     _ completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask? {
        return WSNNetwork.post(baseURL,
                               parameters:["":""],
                               headerFields: ["Content-Type" : "application/json"],
                               parameterEncode: .json,
                               completionHandler: completionHandler)
    }
    /// 菜单标签列表集合
    @discardableResult
    static func loadData(_ parameters: [String : String],
                         _ completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask? {
        return post("ProductList", parameters, { (response) in
            //            completionHandler(response.xao_modelParse(WSNListBaseModel.self))
        })
    }
}
