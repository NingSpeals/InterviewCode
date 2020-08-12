//
//  WSNViewModelSessionManager.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import Foundation


/************************************************** **************************************************/
/***************************************** 视图模型网络活动管理类 *****************************************/
/************************************************** **************************************************/
// MARK: 视图模型网络活动管理类

/// 基于MVVM设计模式封装的视图模型网络活动管理类
@available(iOS 7.0, macOS 10.9, tvOS 9.0, watchOS 2.0, *)
public final class WSNViewModelSessionManager {
    
    /// 记录请求参数
    var parameters = [String : String]()
    /// 记录数据模型的数组
    var datas = [Any]()
    /// 记录是否存在缓存数据
    var isHasCachedData = false
    /// 记录网络任务
    var sessionTask: URLSessionTask? = nil
    /// 记录数据加载状态
    var isLoading: Bool = false
    /// 记录当前页面索引
    var page = 0
    /// 记录偏移量
    var offset = 20
    /// 记录回调事件
    var completionHandler: WSNViewModelCompletionHandler? = nil
    
    
    /// 加载网络任务
    /// - 参数: sessionTask 网络任务
    func load(_ sessionTask: URLSessionTask?) {
       
        // 撤销上次存在的网络任务
        cancelTask()
        isLoading = true
        self.sessionTask = sessionTask
    }
}






/************************************************** **************************************************/
/********************************************** 网络任务 **********************************************/
/************************************************** **************************************************/
// MARK: 网络任务
extension WSNViewModelSessionManager {
    
    /// 开启数据加载任务
    func resumeTask() {
        isLoading = true
        sessionTask?.resume()
    }
    
    /// 暂停数据加载任务
    func suspendTask() {
        isLoading = false
        sessionTask?.suspend()
    }
    
    /// 取消数据加载任务
    func cancelTask() {
        isLoading = false
        sessionTask?.cancel()
    }
}



