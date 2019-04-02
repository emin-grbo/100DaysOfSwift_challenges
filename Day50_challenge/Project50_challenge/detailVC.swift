//
//  detailVC.swift
//  Project50_challenge
//
//  Created by Emin Roblack on 3/25/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import UIKit

class detailVC: UIViewController {

  @IBOutlet var imageView: UIImageView!
  
  var selectedImage: String?
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    if let imagetoLoad = selectedImage {
    
    imageView.image = UIImage(contentsOfFile: imagetoLoad)
    }

        // Do any additional setup after loading the view.
    }
    


}
