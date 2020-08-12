//
//  WSNNetwork.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import Foundation
private let boundary = "Coral"
/********************************************* 基本配置 *********************************************/
// MARK:  基本配置

/// 对URLSession的HTTP网络请求封装类
@available(iOS 7.0, *)
open class WSNNetwork {
   
    /// 设置HTTPS证书，使用HTTPS服务
    /// -  参数： localCertificatePath HTTPS本地证书路径
    public static func setHttps(_ localCertificatePath: String) {
        
        let url = URL(fileURLWithPath:localCertificatePath)
        do {
            let data = try Data(contentsOf: url)
            CLCHttpsServerTrust.setHttps(data)
        } catch {
            print("HTTPS本地证书获取失败!")
        }
    }
    
    
    /// HTTP网络请求
    /// -  参数： httpMethod HTTP请求方式, 默认GET方式.
    /// -  参数： url 网络请求地址.
    /// -  参数： parameters 网络请求参数.
    /// -  参数： headerFields HTTP请求head参数配置.
    /// -  参数： timeoutInterval request时间.
    /// -  参数： completionHandler 数据回调代理.
    /// - 返回值：URLSessionDataTask
    @discardableResult
    static func request(_ urlString: String,
                        httpMethod: WSNHTTPMethod = .get,
                        parameters: WSNHTTPParameters? = nil,
                        headerFields: WSNHTTPHeaders? = nil,
                        timeoutInterval: WSNHTTPTime = 20,
                        threadType: WSNThreadType = .asynchronous,
                        parameterEncode: WSNHTTPParameterEncode = .percentEncodedQuery,
                        completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask? {
        // 构建request
        var request: URLRequest
        do {
            request = try WSNRequest(urlString: urlString,
                                     httpMethod: httpMethod,
                                     parameters: parameters,
                                     headerFields: headerFields,
                                     timeoutInterval: timeoutInterval,
                                     parameterEncode: parameterEncode)
        } catch {
            CoralKit.debugLog("构建网络请求失败： \(error)")
            completionHandler(WSNResponse(error: "构建网络请求失败： \(error)"))
            return nil
        }
        return WSNNetSessionManager.shared.request(threadType: threadType,
                                                   request: request,
                                                   completionHandler: completionHandler)
    }
}







/************************************************** **************************************************/
/***************************************** HTTP网络异步请求方式 *****************************************/
/************************************************** **************************************************/
// MARK:  HTTP网络异步请求方式
extension WSNNetwork {
    
    /// 异步，GET方式的网络请求
    /// -  参数： url 网络请求地址.
    /// -  参数： parameters 网络请求参数.
    /// -  参数： completionHandler 数据处理回调.
    /// - 返回值：URLSessionDataTask
    @discardableResult
    public static func get(_ urlString: String,
                           parameters: WSNHTTPParameters? = nil,
                           headerFields: WSNHTTPHeaders? = ["Content-Type" : "application/json"],
                           completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask? {
        
        return request(urlString,
                       httpMethod: .get,
                       parameters: parameters,
                       headerFields: headerFields,
                       timeoutInterval: 20,
                       threadType: .asynchronous,
                       completionHandler: completionHandler)
    }
    
    /// 异步，POST方式的网络请求
    /// -  参数： url 网络请求地址.
    /// -  参数： parameters 网络请求参数.
    /// -  参数： completionHandler 数据处理回调.
    /// - 返回值：URLSessionDataTask
    @discardableResult
    public static func post(_ urlString: String,
                            parameters: WSNHTTPParameters? = nil,
                            headerFields: WSNHTTPHeaders? = ["Content-Type" : "application/json"],
                            parameterEncode: WSNHTTPParameterEncode = .percentEncodedQuery,
                            completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask? {
        
        return request(urlString,
                       httpMethod: .post,
                       parameters: parameters,
                       headerFields: headerFields,
                       timeoutInterval: 30,
                       threadType: .asynchronous,
                       parameterEncode: parameterEncode,
                       completionHandler: completionHandler)
    }
    
    
    /// 同步，GET方式的网络请求
    /// -  参数： url 网络请求地址.
    /// -  参数： parameters 网络请求参数.
    /// -  参数： timeoutInterval request时间.
    /// -  参数： completionHandler 数据处理回调.
    /// - 返回值：URLSessionDataTask
    @discardableResult
    public static func syncGet(_ urlString: String,
                               parameters: WSNHTTPParameters? = nil,
                               headerFields: WSNHTTPHeaders? = ["Content-Type" : "application/json"],
                               parameterEncode: WSNHTTPParameterEncode = .percentEncodedQuery,
                               completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask? {
        return request(urlString,
                       httpMethod: .post,
                       parameters: parameters,
                       headerFields: headerFields,
                       timeoutInterval: 20,
                       threadType: .synchronous,
                       parameterEncode: parameterEncode,
                       completionHandler: completionHandler)
    }
    
    /// 同步，POST方式的网络请求
    /// -  参数： url 网络请求地址.
    /// -  参数： parameters 网络请求参数.
    /// -  参数： completionHandler 数据处理回调.
    /// - 返回值：URLSessionDataTask
    @discardableResult
    public static func syncPost(_ urlString: String,
                                parameters: WSNHTTPParameters? = nil,
                                headerFields: WSNHTTPHeaders? = ["Content-Type" : "application/json"],
                                parameterEncode: WSNHTTPParameterEncode = .percentEncodedQuery,
                                completionHandler: @escaping WSNNetCompletionHandler) -> URLSessionDataTask? {
        return request(urlString,
                       httpMethod: .post,
                       parameters: parameters,
                       headerFields: headerFields,
                       timeoutInterval: 30,
                       threadType: .synchronous,
                       parameterEncode: parameterEncode,
                       completionHandler: completionHandler)
    }
}



 
