//
//  NetworkManager.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/13.
//

import SystemConfiguration

final public class NetworkManager {
    private init() {}
    
    public static func isConnectedToNetwork() -> Bool {
        guard let flags = getFlags() else { return false }
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }

    private static func getFlags() -> SCNetworkReachabilityFlags? {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com") else { return nil }
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        return flags
    }
}
