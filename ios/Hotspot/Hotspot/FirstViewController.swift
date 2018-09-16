//
//  FirstViewController.swift
//  Hotspot
//
//  Created by Gokul Swamy on 9/15/18.
//  Copyright © 2018 Gokul Swamy. All rights reserved.
//

import UIKit
import SwiftLocation
import Firebase
import CodableFirebase
import CoreMotion

class FirstViewController: UIViewController {
    // Connections to Storyboard
    @IBOutlet weak var totallabel: UILabel!
    @IBOutlet weak var deltalabel: UILabel!
    @IBOutlet weak var latlabel: UILabel!
    @IBOutlet weak var lonlabel: UILabel!
    @IBOutlet weak var ssidlabel: UILabel!
    @IBOutlet weak var slabel: UILabel!
    // Variables
    var totalDist: Double = 0
    var deltaDist: Double = 0
    var heading: Double = 0
    var headingUpdates: Double = 0
    var avgHeading: Double = 0
    var ssid: String = ""
    var strength: Int = 0
    var postingInterval: Double = 0.01
    // Get data
    var ref: DatabaseReference!
    var timer: Timer?
    var pedometer = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get location services setup
        Locator.requestAuthorizationIfNeeded(.always)
        // Setup Database
        ref = Database.database().reference(withPath: "datapoints")
        // Start label updates
        timer = Timer.scheduledTimer(withTimeInterval: self.postingInterval, repeats: true) { [weak self] _ in
            self?.updateWifiStrength()
            self?.updateLabels()
        }
        // Start pedometer updates
        pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
            if let pedData = pedometerData{
                self.deltaDist = Double(truncating: pedData.distance!) - self.totalDist
                self.totalDist = Double(truncating: pedData.distance!)
                self.ssid = WifiScanner.getSSID()
                self.pushData()
            }
        })
        // Start location updates
        Locator.subscribeHeadingUpdates(accuracy: nil, onUpdate: { (heading) -> (Void) in
            self.heading = heading.trueHeading
            self.avgHeading = ((self.headingUpdates * self.avgHeading) + self.heading) / (self.headingUpdates + 1)
            self.headingUpdates = self.headingUpdates + 1
        }) { (headingState) -> (Void) in
            print("error")
        }
    }
    
    func updateWifiStrength() {
        let strength = WifiScanner.wifiStrength()
        if let unwrapped = strength {
            self.strength = unwrapped
        }
    }
    
    func updateLabels() {
        DispatchQueue.main.async {
            self.totallabel.text = "total: " + String(self.totalDist)
            self.deltalabel.text = "delta: " + String(self.deltaDist)
            self.latlabel.text = "avgh: " + String(self.heading)
            self.lonlabel.text = "heading: " + String(self.avgHeading)
            self.ssidlabel.text = "ssid: " + String(self.ssid)
            self.slabel.text = "signal: " + String(self.strength)
        }
    }
    
    func pushData() {
        let time = Date().timeIntervalSince1970.magnitude
        let datapoint = Datapoint(dist: self.deltaDist, heading: self.avgHeading, ssid: self.ssid, strength: Double(self.strength), time: time)
        let datapointRef = self.ref.childByAutoId()
        let encoded = try! FirebaseEncoder().encode(datapoint)
        datapointRef.setValue(encoded)
        self.heading = 0
        self.avgHeading = 0
        self.headingUpdates = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

