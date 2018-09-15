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

    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.google.com/")!
        webView.load(URLRequest(url: url))
//        let mapURL = URL(string: "https://hackmit.org/")
//        if let unwrapped = mapURL {
//            let request = URLRequest(url: unwrapped)
//            let session = URLSession.shared
//            _ = session.dataTask(with: request) { (data, response, error) in
//                if error == nil {
//                    self.webView.load(request)
//                } else {
//                    print(error!)
//                }
//            }
//        } else {
//            print("fuck")
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

