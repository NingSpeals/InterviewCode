//
//  WSNViewModel.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//
import Foundation


/************************************************** **************************************************/
/********************************************* 视图模型基类 ********************************************/
/************************************************** **************************************************/
// MARK: 视图模型基类

/// 基于MVVM设计模式-封装的视图模型基类类
@available(iOS 7.0, macOS 10.9, tvOS 9.0, watchOS 2.0, *)
open class WSNViewModel: WSNViewModelProtocol {
    
    init() {
        loadCachedData()
    }
    
    func loadCachedData() {
        
    }
    
    /// 记录网络任务管理对象
    public final let session = WSNViewModelSessionManager()
    
    /// 获取数据条数
    public final func getCount() -> Int {
        return session.datas.count
    }
    /// 是否存在缓存数据
    public final func isExitCachedData() -> Bool {
        return session.isHasCachedData
    }
    
    /// 数据重置
    public final func reset() {
        session.cancelTask()
        session.parameters.removeAll()
        session.datas.removeAll()
        session.page = 0
        session.completionHandler = nil
    }
    
    /// 销毁存在的网络任务
    deinit {
        session.cancelTask()
        CoralKit.debugLog("<\(self)> 销毁")
    }
    
    
    
    // MARK: 数据模型归档

    /// 数据模型归档
    /// - 参数：model 归档的数据模型对象
    /// - 参数：toFile 归档文件的路径
    public final func archive(_ model: Any, _ toFile: String) {
        let status = NSKeyedArchiver.archiveRootObject(model, toFile: toFile)
        if !status {
            debugPrint("<\(self)> 对象(\(model))归档失败! \n 路径:\(toFile)")
        }
    }
    
    /// 数据模型的解档方法
    /// - 参数：fromFile 将要解档的文件的路径
    public final func unarchiveObject(_ fromFile: String) -> Any? {
        guard let obj = NSKeyedUnarchiver.unarchiveObject(withFile: fromFile) else {
            debugPrint("<\(self)> 文件解档为空! \n 路径:\(fromFile)")
            return nil
        }
        return obj
    }


    // MARK: 数据加载方式

    //// 刷新数据
    /// - 参数： completionHandler 数据任务结束回调事件
    open func refresh(_ completionHandler: @escaping WSNViewModelCompletionHandler) {
        
        session.page = 0
        load(.refresh, completionHandler)
    }
    
    /// 加载更多数据
    /// - 参数： completionHandler 数据任务结束回调事件
    open func loadMore(_ completionHandler: @escaping WSNViewModelCompletionHandler) {
        
        session.page += 1
        load(.loadMore, completionHandler)
    }
    
    /// 指定方式, 加载数据, 用户调用该方法进行网络请求
    /// - 参数： loadType 数据加载方式类型
    /// - 参数： completionHandler 数据任务结束回调事件
    open func load(_ loadType: WSNViewModelLoadType = .refresh,
                   _ completionHandler: @escaping WSNViewModelCompletionHandler) {
        
        if loadType == .loadMore && session.isLoading {
            session.page -= 1
        }
        session.parameters.removeAll()
        session.isLoading = true
        session.completionHandler = completionHandler
    }
}

