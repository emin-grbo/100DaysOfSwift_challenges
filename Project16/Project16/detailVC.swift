//
//  detailVC.swift
//  Project16
//
//  Created by Emin Roblack on 4/3/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import UIKit
import WebKit

class detailVC: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    var city: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://en.wikipedia.org/wiki/\(city!)"
        guard let url = URL(string: urlString) else {return}

        webView.load(URLRequest(url: url))
    }
}
