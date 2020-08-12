//
//  WSNViewModelProtocol.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import Foundation



/// 数据加载类型枚举
public enum WSNViewModelLoadType {
    /// 加载最新数据
    case refresh
    /// 加载更多数据
    case loadMore
}


/// 状态类型枚举
public enum WSNViewModelStatus {
    /// 失败
    case fail
    /// 成功
    case success
    /// 没有数据
    case noData
}



/// 数据加载结果回调处理
/// - 参数： status    数据加载结果状态
/// - 参数： message   状态信息
public typealias WSNViewModelCompletionHandler = (_ status: WSNViewModelStatus, _ message: String) -> Void




/************************************************** **************************************************/
/********************************************* 数据加载方式 ********************************************/
/************************************************** **************************************************/
// MARK: 数据加载方式
public protocol WSNViewModelProtocol {
    //// 刷新数据
    /// - 参数： completionHandler 数据任务结束回调事件
    func refresh(_ completionHandler: @escaping WSNViewModelCompletionHandler)
    
    /// 加载更多数据
    /// - 参数： completionHandler 数据任务结束回调事件
    func loadMore(_ completionHandler: @escaping WSNViewModelCompletionHandler)
    
    /// 指定方式, 加载数据, 用户调用该方法进行网络请求
    /// - 参数： loadType 数据加载方式类型
    /// - 参数： completionHandler 数据任务结束回调事件
    func load(_ loadType: WSNViewModelLoadType, _ completionHandler: @escaping WSNViewModelCompletionHandler)
}



extension WSNViewModelProtocol {
    
    //// 刷新数据
    /// - 参数： completionHandler 数据任务结束回调事件
    func refresh(_ completionHandler: @escaping WSNViewModelCompletionHandler) {
        
        load(.refresh, completionHandler)
    }
    
    /// 加载更多数据
    /// - 参数： completionHandler 数据任务结束回调事件
    func loadMore(_ completionHandler: @escaping WSNViewModelCompletionHandler) {
        
        load(.loadMore, completionHandler)
    }
    
    /// 指定方式, 加载数据, 用户调用该方法进行网络请求
    /// - 参数： loadType 数据加载方式类型
    /// - 参数： completionHandler 数据任务结束回调事件
    func load(_ loadType: WSNViewModelLoadType = .refresh,
              _ completionHandler: @escaping WSNViewModelCompletionHandler) {
        
    }
}

