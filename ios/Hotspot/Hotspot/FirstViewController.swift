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
    
    let motionManager = MotionKit()
    var ref: DatabaseReference!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Locator.requestAuthorizationIfNeeded(.always)
        // Setup Database
        ref = Database.database().reference(withPath: "datapoints")
        // Start label updates
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateLabels()
            self?.pushData()
        }
        // Start motion updates
        motionManager.getAccelerationFromDeviceMotion(interval: 1.0, values: { (x, y, z) in
            self.x = x
            self.y = y
            let strength = WifiScanner.wifiStrength()
            if let unwrapped = strength {
                self.strength = unwrapped
            }
        })
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
            self.xlabel.text = "x: " + String(self.x)
            self.ylabel.text = "y: " + String(self.y)
            self.slabel.text = "s: " + String(self.strength)
            self.latlabel.text = "lat: " + String(self.lat)
            self.lonlabel.text = "lon: " + String(self.lon)
            self.ssidlabel.text = "ssid: " + String(self.ssid)
        }
    }
    
    func pushData() {
        let datapoint = Datapoint(x: self.x, y: self.y, lat: self.lat, lon: self.lon, ssid: self.ssid, strength: Double(self.strength))
        let datapointRef = self.ref.childByAutoId()
        let encoded = try! FirebaseEncoder().encode(datapoint)
        datapointRef.setValue(encoded)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

