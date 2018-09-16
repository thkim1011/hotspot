//
//  Schema.swift
//  Hotspot
//
//  Created by Gokul Swamy on 9/15/18.
//  Copyright © 2018 Gokul Swamy. All rights reserved.
//

import Foundation

struct Datapoint : Codable {
    var dist : Double
    var heading: Double
    var ssid: String
    var strength: Double
    var time: Double
}

struct AccPoint : Codable {
    var xacc : Double
    var yacc : Double
    var time: Double
}
