//
//  WSNModelParseConvertible.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import Foundation



/************************************************** **************************************************/
/***************************************** JSON数据模型解析协议  ****************************************/
/************************************************** **************************************************/
// MARK: 模型类
/// 基于Codable的数据模型解析协议
protocol WSNModelParseConvertible: Codable {
    static func parse(_ data: AnyHashable) throws -> Self?
    var propertyNames: [String] {get}
    var allPropertyNames: [String] {get}
}


extension WSNModelParseConvertible {
    
    /// 当前模型属性名称集合
    var propertyNames: [String] {
        var propertyNames = [String]()
        let mirror = Mirror(reflecting: self)
        for case let (_propertyName, _) in mirror.children {
            guard let propertyName = _propertyName else {
                continue
            }
            propertyNames.append(propertyName)
        }
        return propertyNames
    }
    
    /// 当前模型所有属性名称集合(包括父类...)
    var allPropertyNames: [String] {
        var propertyNameList = [String]()
        let mirror = Mirror(reflecting: self)
        for case let (_propertyName, _) in mirror.children {
            guard let propertyName = _propertyName else {
                continue
            }
            propertyNameList.append(propertyName)
        }
        var superMirror = mirror.superclassMirror
        while let _superMirror = superMirror {
            for case let (_propertyName, _) in _superMirror.children {
                guard let propertyName = _propertyName else {
                    continue
                }
                propertyNameList.append(propertyName)
            }
            superMirror = _superMirror.superclassMirror
        }
        return propertyNameList
    }
    
    /// 数据解析
    static func parse(_ data: AnyHashable) throws -> Self?  {
        if data is String {
            guard let _data = (data as! String).data(using: .utf8) else {
                throw NSError(domain: "数据解析失败：字符串数据utf8编码为空", code: -1, userInfo: nil)
            }
            return try JSONDecoder().decode(self, from: _data)
        } else if data is Data {
            return try JSONDecoder().decode(self, from: data as! Data)
        } else if data is Dictionary<AnyHashable, Any> {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return try JSONDecoder().decode(self, from: jsonData)
        } else if data is Array<Any> {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return try JSONDecoder().decode(self, from: jsonData)
        }
        return nil
    }
}

