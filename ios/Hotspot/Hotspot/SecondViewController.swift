//
//  SecondViewController.swift
//  Hotspot
//
//  Created by Gokul Swamy on 9/15/18.
//  Copyright © 2018 Gokul Swamy. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: UIViewController, WKNavigationDelegate{

    override var prefersStatusBarHidden: Bool {
        return true
    }
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.isOpaque = false
        webView.navigationDelegate = self
        view = webView
        view.backgroundColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Map"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let url = URL(string: "http://192.168.43.9:5000/")!
        webView.load(URLRequest(url: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

