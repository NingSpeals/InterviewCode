//
//  WSNNetSessionManager.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import Foundation

private let boundary = "Coral"


public final class WSNNetSessionManager {

    /// 单例模式
    static let shared = WSNNetSessionManager()
    fileprivate init() {}
    
    /// 记录网络会话配置
    fileprivate var configuration : URLSessionConfiguration = .default
    
    /// 信号量
    fileprivate let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    
    /// URL网络会话
    fileprivate lazy var sessionManager: URLSession = {
        if CLCHttpsServerTrust.openHttps {
            return URLSession(configuration: self.configuration,
                              delegate: CLCHttpsServerTrust(),
                              delegateQueue: nil)
        }
        return URLSession(configuration: self.configuration)
    }()
    
    
    /// 设置网络会话配置
    /// -  参数： configuration 网络会话配置参数
    public static func setSession(_ configuration: URLSessionConfiguration) {
        shared.configuration = configuration
    }
    
    deinit {
        sessionManager.invalidateAndCancel()
    }
}








/************************************************** **************************************************/
/*********************************************** 网络请求 **********************************************/
/************************************************** **************************************************/
// MARK:  网络请求
extension WSNNetSessionManager: CLCHttpRequestProtocol {
    
    /// HTTP网络请求
    /// -  参数： threadType: 线程同步异步类型.
    /// -  参数： request HTTP请求.
    /// -  参数： completionHandler 结果回调代理.
    /// - 返回值：URLSessionDataTask
    public func request(threadType: WSNThreadType,
                        request: WSNRequest,
                        completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask {
        let task = sessionManager.dataTask(with: request) { [weak semaphore] (data, response, error) in
            if threadType == .synchronous {
                semaphore?.signal()
            }
            let cResponse = WSNResponse(data: data,
                                        response: response,
                                        error: error,
                                        encode: .json)
            DispatchQueue.main.async {
                completionHandler(cResponse)
            }
        }
        task.resume()
        if threadType == .synchronous {
            semaphore.wait()
        }
        CoralKit.debugLog("开始HTTP网络数据请求，请求方式：\(request.httpMethod ?? "GET")")
        return task
    }
    
    /// HTTP数据上传请求
    /// -  参数： threadType: 线程同步异步类型.
    /// -  参数： request HTTP请求.
    /// -  参数： completionHandler 结果回调代理.
    /// - 返回值：URLSessionDataTask
    public func upload(threadType: WSNThreadType,
                       request: WSNRequest,
                       data: Data,
                       completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask {
        
        var request = request
        request.timeoutInterval = 60
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        let task = sessionManager.uploadTask(with: request, from: data) { [weak semaphore] (data, response, error) in
            if threadType == .synchronous {
                semaphore?.signal()
            }
            let cResponse = WSNResponse(data: data,
                                        response: response,
                                        error: error,
                                        encode: .json)
            DispatchQueue.main.async {
                completionHandler(cResponse)
            }
        }
        task.resume()
        if threadType == .synchronous {
            semaphore.wait()
        }
        CoralKit.debugLog("开始HTTP网络数据请求，请求方式：\(request.httpMethod ?? "GET")")
        return task
    }
    
    /// HTTP表单数据上传请求
    /// -  参数： threadType: 线程同步异步类型.
    /// -  参数： request HTTP请求.
    /// -  参数： formaDataBlock 表单数据添加的回调.
    /// -  参数： completionHandler 结果回调代理.
    /// - 返回值：URLSessionDataTask
    public func formDataUpload(threadType: WSNThreadType,
                               request: WSNRequest,
                               formaDataBlock: @escaping CLCFormDataBlock,
                               completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask {
        
        var request = request
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let mutipartFormData = CLCMutipartFormData()
        formaDataBlock(mutipartFormData)
        return upload(threadType: threadType,
                      request: request,
                      data: mutipartFormData.formData,
                      completionHandler: completionHandler)
    }
}






public enum WSNThreadType {
    /// 同步
    case synchronous
    /// 异步
    case asynchronous
}

public typealias CLCFormDataBlock = (CLCMutipartFormData)->Void

public protocol CLCHttpRequestProtocol {
    
    /// HTTP网络请求
    /// -  参数： threadType: 线程同步异步类型.
    /// -  参数： request HTTP请求.
    /// -  参数： completionHandler 结果回调代理.
    /// - 返回值：URLSessionDataTask
    func request(threadType: WSNThreadType,
                 request: WSNRequest,
                 completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask
    
    /// HTTP数据上传请求
    /// -  参数： threadType: 线程同步异步类型.
    /// -  参数： request HTTP请求.
    /// -  参数： completionHandler 结果回调代理.
    /// - 返回值：URLSessionDataTask
    func upload(threadType: WSNThreadType,
                request: WSNRequest,
                data: Data,
                completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask
    
    /// HTTP表单数据上传请求
    /// -  参数： threadType: 线程同步异步类型.
    /// -  参数： request HTTP请求.
    /// -  参数： formaDataBlock 表单数据添加的回调.
    /// -  参数： completionHandler 结果回调代理.
    /// - 返回值：URLSessionDataTask
    func formDataUpload(threadType: WSNThreadType,
                        request: WSNRequest,
                        formaDataBlock: @escaping CLCFormDataBlock,
                        completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask
}

 

