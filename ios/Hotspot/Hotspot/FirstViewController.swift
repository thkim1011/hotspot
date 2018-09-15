//
//  FirstViewController.swift
//  Hotspot
//
//  Created by Gokul Swamy on 9/15/18.
//  Copyright © 2018 Gokul Swamy. All rights reserved.
//

import UIKit
import SwiftLocation
import MotionKit
import Firebase
import CodableFirebase

class FirstViewController: UIViewController {
    // Connections to Storyboard
    @IBOutlet weak var xlabel: UILabel!
    @IBOutlet weak var ylabel: UILabel!
    @IBOutlet weak var latlabel: UILabel!
    @IBOutlet weak var lonlabel: UILabel!
    @IBOutlet weak var ssidlabel: UILabel!
    @IBOutlet weak var slabel: UILabel!
    // Variables
    var x: Double = 0
    var y: Double = 0
    var lat: Double = 0
    var lon: Double = 0
    var ssid: String = ""
    var strength: Int = -1
    var postingInterval: Double = 1.0
    var integratingInterval: Double = 0.01
    // State
    var vx: Double = 0
    var vy: Double = 0
    var dx: Double = 0
    var dy: Double = 0
    // Get data
    let motionManager = MotionKit()
    var ref: DatabaseReference!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Locator.requestAuthorizationIfNeeded(.always)
        // Setup Database
        ref = Database.database().reference(withPath: "datapoints")
        // Start label updates
        timer = Timer.scheduledTimer(withTimeInterval: self.postingInterval, repeats: true) { [weak self] _ in
            self?.updateLabels()
            //self?.pushData()
        }
        motionManager.getDeviceMotionObject(interval: integratingInterval) { (motion) in
            let acc = motion.userAccelerationInReferenceFrame()
            self.x = acc.x * 9.81
            self.y = acc.y * 9.81
            self.dx = self.dx + (self.vx * self.integratingInterval) + (self.x * self.integratingInterval * self.integratingInterval * 0.5)
            self.dy = self.dy + (self.vy * self.integratingInterval) + (self.y * self.integratingInterval * self.integratingInterval * 0.5)
            self.vx = self.vx + (self.x * self.integratingInterval)
            self.vy = self.vy + (self.y * self.integratingInterval)
            let strength = WifiScanner.wifiStrength()
            if let unwrapped = strength {
                self.strength = unwrapped
            }

        }
        
        
        
        
        // Start motion updates
//        motionManager.getAccelerationFromDeviceMotion(interval: self.postingInterval, values: { (x, y, z) in
//            self.motionManager.getAttitudeFromDeviceMotion(values: { (attitude) in
//
//
//                let inv = attitude.rotationMatrix.inverse()
//                self.x = x*inv.m11 + y*inv.m12 + z*inv.m13
//                self.y = x*inv.m21 + y*inv.m22 + z*inv.m23
                self.dx = self.dx + (self.vx * self.integratingInterval) + (self.x * self.integratingInterval * self.integratingInterval * 0.5)
                self.dy = self.dy + (self.vy * self.integratingInterval) + (self.y * self.integratingInterval * self.integratingInterval * 0.5)
                self.vx = self.vx + (self.x * self.integratingInterval)
                self.vy = self.vy + (self.y * self.integratingInterval)
//                // Get wifi strength
//            })
//        })
        // Start location updates
        Locator.subscribePosition(accuracy: .room, onUpdate: { (location) -> (Void) in
            self.lat = location.coordinate.latitude
            self.lon = location.coordinate.longitude
            self.ssid = WifiScanner.getSSID()
        }) { (error, loc) -> (Void) in
            // pass
        }
    }
    
    func updateLabels() {
        DispatchQueue.main.async {
            self.xlabel.text = "dx: " + String(self.dx)
            self.ylabel.text = "dy: " + String(self.dy)
            self.slabel.text = "s: " + String(self.strength)
            self.latlabel.text = "vx: " + String(self.vx)
            self.lonlabel.text = "vy: " + String(self.vy)
            self.ssidlabel.text = "ssid: " + String(self.ssid)
        }
    }
    
    func pushData() {
        let time = Date().timeIntervalSince1970.magnitude
        let datapoint = Datapoint(xpos: self.dx, ypos: self.dy, lat: self.lat, lon: self.lon, ssid: self.ssid, strength: Double(self.strength), time: time)
        let datapointRef = self.ref.childByAutoId()
        let encoded = try! FirebaseEncoder().encode(datapoint)
        datapointRef.setValue(encoded)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

