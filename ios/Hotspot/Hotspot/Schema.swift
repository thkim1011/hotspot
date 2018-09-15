//
//  Schema.swift
//  Hotspot
//
//  Created by Gokul Swamy on 9/15/18.
//  Copyright © 2018 Gokul Swamy. All rights reserved.
//

import Foundation

struct Datapoint : Codable {
    var x : Double
    var y : Double
    var lat: Double
    var lon: Double
    var ssid: String
    var strength: Double
}
