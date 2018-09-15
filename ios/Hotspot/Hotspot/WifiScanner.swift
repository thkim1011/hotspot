//
//  SSID.swift
//  Hotspot
//
//  Created by Gokul Swamy on 9/15/18.
//  Copyright © 2018 Gokul Swamy. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork

public class WifiScanner {
    class func getSSID() -> String {
        var currentSSID = ""
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces) {
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as Dictionary?
                    currentSSID = interfaceData!["SSID" as NSString] as! String
                }
            }
        }
        return currentSSID
    }
    class func wifiStrength() -> Int? {
        let app = UIApplication.shared
        var rssi: Int?
        guard let statusBar = app.value(forKey: "statusBar") as? UIView, let foregroundView = statusBar.value(forKey: "foregroundView") as? UIView else {
            return rssi
        }
        for view in foregroundView.subviews {
            if let statusBarDataNetworkItemView = NSClassFromString("UIStatusBarDataNetworkItemView"), view .isKind(of: statusBarDataNetworkItemView) {
                if let val = view.value(forKey: "wifiStrengthRaw") as? Int {
                    //print("rssi: \(val)")
                    
                    rssi = val
                    break
                }
            }
        }
        return rssi
    }
}
