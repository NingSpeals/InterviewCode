//
//  WSNModel.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

//
//  CLModel.swift
//  Coral
//
//  Created by 徐玉珊 on 2017/11/3.
//  Copyright © 2017年 XYS. All rights reserved.
//

import Foundation
/************************************************** **************************************************/
/*********************************************** 模型类  **********************************************/
/************************************************** **************************************************/
// MARK: 模型类
@available(iOS 7.0, macOS 10.9, tvOS 9.0, watchOS 2.0, *)
open class WSNModel: NSObject, Codable {
    
    /// 重写该方法，使type(of: self).init()创建对象的方法，子类也可以兼容继承
    required override public init () {
        super.init()
    }
    
    /// 解档操作
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        
        let propertyNameList = self.propertyNameList()
        for propertyName in propertyNameList {
            guard let value = aDecoder.decodeObject(forKey: propertyName) else {
                continue
            }
            setValue(value, forKey: propertyName)
        }
    }
    
    /// 获取实例所有属性名称的字符串数组.
    /// - 返回值： 返回所有属性名称的字符串数组, 没有属性时，会返回空数组.
    final public func propertyNameList() -> [String] {
        
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
    
    
    /// JSON数据解析，可以解析字典类型、数组类型、相关Data类型.
    /// - 参数： withData 建议传入字典、数组类型
    /// - 返回值： 任意类型, 发生异常时，抛出 ErrorMessage, 返回nil
    /// - 注意：
    ///      1. 使用该方法的类型，必须是CLCModel的子类.
    ///      2. 请求使用 arrayTypes() 添加数组的元素类型。
    ///      3. 数组内的元素类型不是相同的字典数据时, 请自行处理。（建议：请求重写该方法解析指定的类型）
    ///      4. 当字典对象解析异常时，也可以使用arrayTypes()添加字典解析对象类型.
    ///      5. 传入的字典的解析类型或者数组的元素类型必须是调用该方法的类型
    @discardableResult
    open class func parse(_ withData: Any?) throws -> Any? {
        
        guard let data = withData else {
            return nil
        }
        
        do {
            // 解析字典类型数据
            if data is Dictionary<String, Any> {
                return try dictionaryParse(withData: data as? NSDictionary)
            }
            
            // 解析数组类型数据
            if data is Array<Any> {
                return try arrayParse(withData: data as? Array<Any>)
            }
        } catch {
            throw error
        }
        
        // 解析二进制类型数据
        if data is Data {
            do {
                let options: JSONSerialization.ReadingOptions = [.mutableContainers, .mutableLeaves, .allowFragments]
                let tempData = try JSONSerialization.jsonObject(with: data as! Data, options: options)
                if tempData is NSDictionary || tempData is Array<Any> || tempData is String {
                    do {
                        return try parse(tempData)
                    } catch {
                        throw error
                    }
                } else {
                    throw CLCError.message("\(self): 无法解析数据! 数据可能不是JSON格式的字节数据！")
                }
            } catch {
                throw CLCError.message("\(self): JSON反序列化失败！\(error)")
            }
        }
        
        return nil
    }
    /**************************************** 解析的 特殊处理 ****************************************/
    // MARK: 解析的特殊处理
    
    /// 存储需要替换的属性和解析key
    /// - 格式： [解析key : 自定义属性名]
    /// - 返回值： 字典类型
    open class func specialProperties() -> Dictionary<String, String> {
        return [:]
    }
    
    /// 存储数组中的元素类型, 也可以存储属性对象类型
    /// - 格式： [属性名 : 类名]
    /// - 返回值： 字典类型
    open class func specialClassTypes() -> Dictionary<String, String> {
        return [:]
    }
}
/************************************************** **************************************************/
/********************************************** 解析方法 **********************************************/
/************************************************** **************************************************/
// MARK: 解析方法
extension WSNModel {
    
    
    /// JSON数组数据解析
    /// - 参数： withData JSON数组数据.
    /// - 返回值： Array<Any> 发生异常时，抛出 ErrorMessage, 返回nil.
    /// - 注意：
    ///      1. 使用该方法的类型ObjectClass，必须是CLCModel的子类(需要解析成的类型).
    ///      2. 传入的数组元素类型必须是调用该方法的类型ObjectClass.
    @discardableResult
    private static func arrayParse(withData: Array<Any>?) throws -> Array<Any>? {
        do {
            return try arrayParse(withData: withData, elementType: "\(self)")
        } catch {
            throw error
        }
    }
    
    /// JSON数组数据解析，必须统一数组元素类.
    /// - 参数： withData JSON数组数据.
    /// - 参数： elementType 数组数据元素类型.
    /// - 返回值： Array<Any> 发生异常时，抛出 ErrorMessage, 返回nil.
    /// - 注意：
    ///      1. 传入的数组元素类型elementType必须是统一的CLCModel子类类型.
    @discardableResult
    static func arrayParse(withData: Array<Any>?, elementType: String) throws -> Array<Any>? {
        guard let arrayData = withData else {
            return nil
        }
        
        if let classObject = CoralKit.classFrom(elementType),
            classObject is NSDictionary.Type  ||
                classObject is String.Type ||
                classObject is NSNumber.Type {
            return withData
        }
        
        var temp: Array<Any> = [Any]()
        for item in arrayData {
            
            if item is NSDictionary {
                do {
                    guard let classObject = CoralKit.classFrom(elementType) else {
                        continue
                    }
                    guard let classObjectFromBaseModel = classObject as? WSNModel.Type else {
                        throw CLCError.message("\(self): \(classObject) 不是CLCModel的子类！解析失败，请继承CLCModel")
                    }
                    let obj = try classObjectFromBaseModel.parse(item)
                    if let obj1 = obj {
                        temp.append(obj1)
                    }
                    
                } catch {
                    throw error
                }
            } else if item is Array<Any> {
                do {
                    let obj = try arrayParse(withData: item as? Array<Any>, elementType: elementType)
                    guard let obj1 = obj else {
                        continue
                    }
                    temp.append(obj1)
                } catch {
                    throw error
                }
            } else {
                return withData
            }
        }
        return temp
    }
    
    /// JSON键值对数据解析.
    /// - 参数： withData JSON键值对数据.
    /// - 返回值： AnyObject,  发生异常时，抛出 ErrorMessage, 返回nil.
    /// - 注意：
    ///      1. 使用该方法的类型ObjectClass，必须是CLCModel的子类(需要解析成的类型).
    ///      2. 传入的字典解析类型必须是调用该方法的类型ObjectClass.
    @discardableResult
    private static func dictionaryParse(withData: NSDictionary?) throws -> Any? {
        guard let dicData = withData else {
            return nil
        }
        
        let obj = self.init()
        let propertyNameList = obj.propertyNameList()
        let specialProperties = self.specialProperties()
        let specialClassTypes = self.specialClassTypes()
        
        for (key, value) in dicData {
            
            // 忽略不必要的属性
            if !propertyNameList.contains("\(key)") && !specialProperties.keys.contains("\(key)") {
                continue
            }
            
            // 获取属性名称字符串
            let propertyName = specialProperties["\(key)"] ?? "\(key)"
            
            // 字典数据解析成对象
            if value is NSDictionary {
                guard let className = specialClassTypes[propertyName] else {
                    throw CLCError.message("\(self): \(propertyName) 字典类型数据解析错误！无法获取对象类型！请在specialClassTypes()方法中添加解析类型。")
                }
                guard let classObject = CoralKit.classFrom(className) else {
                    throw CLCError.message("\(self): \(propertyName) 实例化对象失败！")
                }
                guard let classObjectFromBaseModel = classObject as? WSNModel.Type else {
                    throw CLCError.message("\(obj): \(classObject) 不是CLCModel的子类！解析失败，请继承CLCModel。")
                }
                do {
                    let dicValue = try classObjectFromBaseModel.parse(value)
                    obj.setValue(dicValue, forKey: propertyName)
                } catch {
                    throw error
                }
                
            } else if value is Array<Any> {
                // 数组数据解析
                do {
                    guard let elementType = specialClassTypes[propertyName] else {
                        throw CLCError.message("\(obj):\(propertyName) 无法获取到数组中的元素类型！")
                    }
                    let arrayData = try arrayParse(withData: value as? Array<Any>,
                                                   elementType: elementType)
                    obj.setValue(arrayData, forKey: propertyName)
                    
                } catch {
                    throw error
                }
                
            } else {
                // NSNull对象处理
                if value is NSNull {
                    continue
                }
                if value is String  {
                    if value as! String == ""{
                        continue
                    }
                }
                obj.setValue(value, forKey: propertyName)
            }
        }
        
        return obj
    }
    
}
/************************************************** **************************************************/
/******************************************** 解析的容错处理 ********************************************/
/************************************************** **************************************************/
// MARK: 解析的容错处理
extension WSNModel {
    /// 忽略对不存在的属性进行赋值操作
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    /// 对不存在的属性进行取值操作，返回nil
    override open func value(forUndefinedKey key: String) -> Any? {
        
        return nil
    }
    /// 忽略对数字类型的nil赋值操作，自动修改为0
    override open func setNilValueForKey(_ key: String) {
        
        if let value = value(forKey: key) {
            if value is NSNumber {
                setValue(0, forKey: key)
            }
        }
    }
}

/************************************************** **************************************************/
/******************************************* NSCopying 协议 *******************************************/
/************************************************** **************************************************/
// MARK: NSCopying 协议
extension WSNModel: NSCopying {
    
    /// 自实现copying方法，仅仅拷贝属性内容
    final public func copy(with zone: NSZone? = nil) -> Any {
        
        let newObject = type(of: self).init()
        let propertyNameList = self.propertyNameList()
        for propertyName in propertyNameList {
            guard let value = value(forKey: propertyName) else {
                continue
            }
            newObject.setValue(value, forKey: propertyName)
        }
        return newObject
    }
}

/************************************************** **************************************************/
/******************************************* NSCoding 协议 *******************************************/
/************************************************** **************************************************/
// MARK: NSCoding 协议
extension WSNModel: NSCoding {
    /// 自实现NSCoding方法，仅仅设置属性内容
    // - 注意： 使用KVC时值类型和属性类型要一致，否则会导致crash
    final public func encode(with aCoder: NSCoder) {
        
        let propertyNameList = self.propertyNameList()
        for propertyName in propertyNameList {
            guard let value = value(forKey: propertyName) else {
                continue
            }
            aCoder.encode(value, forKey: propertyName)
        }
    }
}



