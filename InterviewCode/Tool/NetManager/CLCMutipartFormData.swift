//
//  CLCMutipartFormData.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import Foundation

private let boundary = "Coral"


/// 表单数据构造类
@available(iOS 7.0, macOS 10.9, tvOS 9.0, watchOS 2.0, *)
open class CLCMutipartFormData {

    /// 记录表单body数据
    private var bodyData = Data()
    
    /// 构造好的表单数据
    public final var formData: Data  {
        get {
            return createFormData()
        }
    }
    
    
    /// 添加表单文件数据
    /// -  参数： data 文件数据.
    /// -  参数： name 文件名.
    /// -  参数： fileName 文件名全称(带.后缀).
    /// -  参数： mimeType 数据响应类型，默认为二进制数据流
    public final func append(_ data: Data,
                             _ name: String,
                             _ fileName: String,
                             _ mimeType: String = "application/octet-stream") {
        
        guard let line = encodeText("\r\n"),
            let startBoundary = encodeText("--\(boundary)"),
            let contentDisposition = encodeText("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\""),
            let contentType = encodeText("Content-Type: \(mimeType)") else {
                CoralKit.debugLog("<\(self)>表单数据构造参数错误！")
                return
        }
        objc_sync_enter(bodyData)
        
        bodyData.append(startBoundary)
        bodyData.append(line)
        bodyData.append(contentDisposition)
        bodyData.append(line)
        bodyData.append(contentType)
        bodyData.append(line)
        bodyData.append(line)
        bodyData.append(data)
        bodyData.append(line)
        
        objc_sync_exit(bodyData)
    }
    
    /// 添加表单文件数据
    /// -  参数： datas 文件数据集合.
    /// -  参数： normalName 一般文件名, 自动添加0+来补充名称.
    /// -  参数： fileType 文件名后缀
    /// -  参数： mimeType 数据响应类型，默认为二进制数据流
    public final func append(_ datas: [Data],
                             _ normalName: String,
                             _ fileType: String,
                             _ mimeType: String = "application/octet-stream") {
        
        let count = datas.count
        for item in 0..<count {
            let name = normalName.appending("\(item)")
            let fileName = name.appending(".\(fileType)")
            append(datas[item], name, fileName , mimeType)
        }
    }
    
    /// 添加表单字符串数据
    /// -  参数： name 字符串名称.
    /// -  参数： text 字符串.
    /// -  参数： mimeType 数据响应类型，默认为文本类型
    public final func append(_ name: String,
                             _ text: String,
                             _ mimeType: String = "text/plain") {
        
        guard let line = encodeText("\r\n"),
            let startBoundary = encodeText("--\(boundary)"),
            let contentDisposition = encodeText("Content-Disposition: form-data; name=\"\(name)\"; "),
            let contentType = encodeText("Content-Type: \(mimeType)"),
            let data = encodeText(text) else {
                CoralKit.debugLog("<\(self)>表单数据构造参数错误！")
                return
        }
        
        objc_sync_enter(bodyData)
        
        bodyData.append(startBoundary)
        bodyData.append(line)
        bodyData.append(contentDisposition)
        bodyData.append(line)
        bodyData.append(contentType)
        bodyData.append(line)
        bodyData.append(line)
        bodyData.append(data)
        bodyData.append(line)
        
        objc_sync_exit(bodyData)
    }
    
    /// 添加表单字符串数据
    /// -  参数： texts 字符串集合(字符串名称 : 字符串内容).
    /// -  参数： mimeType 数据响应类型，默认为文本类型
    public final func append(_ texts: [String : String],
                             _ mimeType: String = "text/plain") {
        
        for (name, text) in texts {
            append(name, text, mimeType)
        }
    }
    
    
    
    /// 构造表单数据尾部
    private func createTail() -> Data {
        
        guard let line = encodeText("\r\n"),
            let endBoundary = encodeText("--\(boundary)--") else {
                return Data()
        }
        var data = Data()
        data.append(line)
        data.append(endBoundary)
        data.append(line)
        
        return data
    }
    
    
    /// 构造表单数据
    private func createFormData() -> Data {

        var data = Data()
        data.append(bodyData)
        data.append(createTail())
        return data
    }
    
    
    /// 字符串内容编码
    private func encodeText(_ text: String) -> Data? {
        
        return text.data(using: .utf8, allowLossyConversion: false)
    }
}
