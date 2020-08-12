//
//  WSNResponse.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import UIKit


/// 网络请求结果状态枚举
public enum WSNResponseStatus {
    /// 网络请求失败
    case fail
    /// 网络请求成功
    case success
}

/// 网络请求结果状态枚举
public enum WSNNetDataStatus {
    /// 数据正常
    case noError
    /// 空数据
    case empty
    /// json反序列化数据失败
    case jsonError
}



/// 网络数据加载回调
/// -  参数： data 请求得到的网络数据
/// -  参数： status 网络请求的结果状态
/// -  参数： message 附加描述信息
public typealias WSNNetCompletionHandler = (_ response: WSNResponse) -> Void


public enum WSNNetResultEncode {
    case json
    case data
}

public final class WSNResponse {
    
    var status: WSNResponseStatus = .fail
    var dataStatus: WSNNetDataStatus = .empty
    var statusCode: Int = 0
    var data: Any? = nil
    var message: String = "网络请求失败!"
   
    /// HTTP网络请求结果处理.
    /// -  参数： request HTTP网络请求.
    /// -  参数： data 服务器反馈的数据.
    /// -  参数： response 服务器回复.
    /// -  参数： error 错误信息.
    /// - 返回值：URLSessionDataTask
    @discardableResult
    init(data: Data?,
         response: URLResponse?,
         error: Error?,
         encode: WSNNetResultEncode = .data) {
        
        statusCode = checkStatusCode(response)
        if statusCode == 200 {
            status = .success
            if let _data = data {
                if encode == .json {
                    jsonEncode(_data)
                } else {
                    self.data = _data
                }
                if self.data != nil {
                    dataStatus = .noError
                    message = "网络请求成功"
                } else {
                    message = "没有数据"
                }
            }
        } else {
            if let _error = error {
                message = _error.localizedDescription
            }
        }
        debugLog(response)
    }
    
    init(error: String) {
        message = error
    }
    
    
    private func debugLog(_ response: URLResponse?) {
        
        #if DEBUG
            if status == .success {
                print("""
                    网络请求成功!
                    网络请求地址：\(response?.url?.absoluteString ?? "未知")
                    """)
            } else {
                print("网络请求失败!")
            }
            if dataStatus == .noError {
                print("数据处理正常!")
            } else {
                print("数据状态处理异常!")
            }
            print(message)
            print("""
                状态码：\(statusCode)
                数据文本编码类型：\(response?.textEncodingName ?? "")
                MIME类型：\(response?.mimeType ?? "")
                """)
        #endif
    }
    
    
    // 获取HTTP状态码
    /// -  参数： completionHandler 数据回调代理.
    private func checkStatusCode(_ byResponse: URLResponse?) -> Int {
        var httpCode = 0
        if let re = byResponse as? HTTPURLResponse {
            httpCode = re.statusCode
        }
        return httpCode
    }
    
    
    private func jsonEncode(_ data: Data) {
        do {
            let options: JSONSerialization.ReadingOptions = [.mutableContainers,
                                                             .mutableLeaves,
                                                             .allowFragments]
            self.data = try JSONSerialization.jsonObject(with: data, options: options)
        } catch {
            dataStatus = .jsonError
            message = "json反序列化数据失败"
        }
    }
}
