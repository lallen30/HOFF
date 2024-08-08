//
//  Reachability.swift
//  GearTrakr
//
//  Created by Digvijay Ghildiyal on 08/06/22.
//
import Foundation
import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(nil, $0)
                
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        if !isReachable && !needsConnection {
            return (isReachable && needsConnection)
        }
        
        return (isReachable && !needsConnection)
    }
}
