//
//  Coral.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//
import Foundation


/// CoralKit 工具类
@available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, *)
public struct CoralKit {
    
    private init() {}
    
    /// 在DEBUG模式下打印日志文件
    /// - 参数：withMessage 日志信息
    static func debugLog(_ withMessage: String?) {
        #if DEBUG
            print(withMessage ?? "空白打印")
        #endif
    }
    static func debugLog(withJSONObject: Any?) {
        if withJSONObject == nil {
            return
         }
        if let jsonData = try? JSONSerialization.data(withJSONObject: withJSONObject as! NSDictionary, options: JSONSerialization.WritingOptions.init(rawValue: 0)){
            let jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
            #if DEBUG
            print("网络请求结果: \n\(jsonStr ?? " ")" )
            #endif
        }
    }
    /// 通过类名创建对象
    /// - 参数：name 类名称字符串
    /// - 返回值：类型对象
    static func classFrom(_ name: String) -> AnyClass? {
        if let _class = NSClassFromString(CoralKit.projectName + "." + name) {
            return _class
        }
        return NSClassFromString(name)
    }
}



// MARK: 归档的相关处理
extension CoralKit {
    
    /// 对象的归档方法
    /// - 参数：withObject 归档的对象
    /// - 参数：toFile 归档文件的路径
    /// - 返回值：归档结果的状态
    @discardableResult
    public static func archive(_ withObject: Any, _ toFile: String) -> Bool {
        let status = NSKeyedArchiver.archiveRootObject(withObject, toFile: toFile)
        if !status {
            debugLog("对象归档失败! \(withObject)\n 路径:\(toFile)")
        }
        return status
    }
    
    /// 对象的解档方法
    /// - 参数：fromFile 将要解档的文件的路径
    public static func unarchiveObject(_ fromFile: String) -> Any? {
        guard let obj = NSKeyedUnarchiver.unarchiveObject(withFile: fromFile) else {
            debugLog("解档文件为空! \n路径:\(fromFile)")
            return nil
        }
        return obj
    }
}



public extension CoralKit {
    
    /// 项目工程名称
    public static let projectName = Bundle.main.bundlePath.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? "UnknownProject"
    /// 应用程序名称
    public static let applicationName = "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") ?? projectName)"
    
    /// 项目版本
    public static let version = "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "0.0.0")"
    /// 项目测试版本
    public static let buildVersion = "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? "0.0.0")"
}



public enum CLCError: Error {
    /// 记录错误信息
    case message(String)
}
