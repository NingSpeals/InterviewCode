//
//  WSNRequest.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import UIKit




/// HTTP请求方式枚举
/// 参考https://tools.ietf.org/html/rfc7231#section-4.3
public enum WSNHTTPMethod: String {
    /// GET请求方式
    case get = "GET"
    /// POST请求方式
    case post = "POST"
    /// HEAD请求方式
    case head = "HEAD"
    case options = "OPTIONS"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

/// 参数编码方式
public enum WSNHTTPParameterEncode {
    /// json
    case json
    /// query
    case query
    /// query
    case percentEncodedQuery
}

public typealias WSNRequest = URLRequest
public typealias WSNHTTPParameters = [String: Any]
public typealias WSNHTTPHeaders = [String: String]
public typealias WSNHTTPTime = TimeInterval



extension WSNRequest {
    
    public init(urlString: String,
                httpMethod: WSNHTTPMethod = .get,
                parameters: WSNHTTPParameters? = nil,
                headerFields: WSNHTTPHeaders? = nil,
                timeoutInterval: WSNHTTPTime = 20,
                parameterEncode: WSNHTTPParameterEncode = .percentEncodedQuery) throws {
        
        let url = try urlString.createURL()
        self.init(url: url)
        self.httpMethod = httpMethod.rawValue
        self.timeoutInterval = timeoutInterval
        if let headers = headerFields {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        if let params = parameters {
            if encodesParametersInURL(with: httpMethod) {
                if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + params.queryString().percentEncoding()
                    urlComponents.percentEncodedQuery = percentEncodedQuery
                    self.url = urlComponents.url
                }
            } else {
                if parameterEncode == .percentEncodedQuery {
                    httpBody = params.queryString().percentEncoding().utf8Data()
                } else if parameterEncode == .json {
                    httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                } else {
                    httpBody = params.queryString().utf8Data()
                }
            }
        }
        #if DEBUG
            print("开始网络数据请求， 请求方式：\(httpMethod.rawValue)")
            print("网络请求地址：\(urlString)")
            print("网络请求参数：\(parameters?.description ?? "空参数")")
        #endif
    }
    
    
    private func encodesParametersInURL(with method: WSNHTTPMethod) -> Bool {
        switch method {
        case .get, .head, .delete:
            return true
        default:
            return false
        }
    }
}







/************************************************** **************************************************/
/*********************************************** 构造URL **********************************************/
/************************************************** **************************************************/
// MARK:  构造URL

public protocol CLURLConvertible {
    
    /// 构造HTTP网络地址url
    func createURL() throws -> URL
}

extension String: CLURLConvertible {
   
    /// 构造HTTP网络地址url
    public func createURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw CLCError.message("构建url失败!")
        }
        return url
    }
}








/************************************************** **************************************************/
/*********************************************** 构造参数 **********************************************/
/************************************************** **************************************************/
// MARK:  构造参数

protocol CLCHTTPParametersConvertible {
    /// 获取HTTP参数拼接的字符串
    func queryString() -> String
    /// 获取HTTP参数拼接的二进制数据
    func httpBody() -> Data?
    
}


extension Dictionary: CLCHTTPParametersConvertible {
    
    /// 获取HTTP参数拼接的字符串
    func queryString() -> String {
        let requestBody = self.map{ "\($0)=\($1)" }.joined(separator: "&")
        return requestBody
    }
    
    /// 获取HTTP参数拼接的二进制数据
    func httpBody() -> Data? {
        return queryString().data(using: .utf8, allowLossyConversion: false)
    }
}


private extension String {
    
    func percentEncoding() -> String {
        let cSet = CharacterSet(charactersIn: "&=")
        return description.addingPercentEncoding(withAllowedCharacters: cSet) ?? description
    }
    
    /// 二进制数据
    func utf8Data() -> Data? {
        return description.data(using: .utf8, allowLossyConversion: false)
    }
}

