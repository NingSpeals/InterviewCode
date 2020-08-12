//
//  CLCHttpsServerTrust.swift
//  InterviewCode
//
//  Created by Ning on 2020/7/16.
//  Copyright © 2020 Ning. All rights reserved.
//

import UIKit


@available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, *)
public final class CLCHttpsServerTrust: NSObject {
    
    /// 是否开启HTTPS
    public static var openHttps : Bool = false
    /// 记录本地HTTPS证书
    fileprivate static var localCertificate : Data? = nil

    
    /// 设置HTTPS证书，使用HTTPS服务
    /// -  参数： localCertificate HTTPS本地证书
    public static func setHttps(_ localCertificate: Data) {
        
        self.localCertificate = localCertificate
        openHttps = true
    }
    
    
    /// 服务器认证
    public func serverTrust(session: URLSession,
                             challenge: URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        
        
        var disposition: URLSession.AuthChallengeDisposition = .cancelAuthenticationChallenge
        var credential: URLCredential? = nil
        
        // 获取远程服务器证书
        guard let serverTrust = challenge.protectionSpace.serverTrust,
            let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0),
            let remoteCertificateData = CFBridgingRetain(SecCertificateCopyData(certificate)) else {
                return (disposition, credential)
        }
        
        // 本地证书校验
        if let _certificate = CLCHttpsServerTrust.localCertificate,
            remoteCertificateData.isEqual(_certificate) {
            disposition = .useCredential
            credential = URLCredential(trust: serverTrust)
        }

        return (disposition, credential)
    }

}

extension CLCHttpsServerTrust: URLSessionDelegate {


    // MARK: URLSessionDelegate

    public func urlSession(_ session: URLSession,
                           didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        
        if !CLCHttpsServerTrust.openHttps {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        // 认证方式匹配
        let method = challenge.protectionSpace.authenticationMethod
        if method == NSURLAuthenticationMethodServerTrust {
            let (disposition, credential) = serverTrust(session: session, challenge: challenge)
            completionHandler(disposition, credential)

        } else {
            CoralKit.debugLog("拒绝的https安全认证!")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}


