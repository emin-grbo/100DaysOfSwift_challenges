//
//  DetailViewController.swift
//  Project1
//
//  Created by roblack on 12/08/2016.
//  Copyright © 2016 roblack All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	@IBOutlet var imageView: UIImageView!
	var selectedImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()

		title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

		if let imageToLoad = selectedImage {
			imageView.image  = UIImage(named: imageToLoad)
		}
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

	@objc func shareTapped() {
        
        let imagetoShare = renderShareImage()
        
		let vc = UIActivityViewController(activityItems: [imagetoShare], applicationActivities: [])
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}
    
    func renderShareImage() -> UIImage {
        
        guard let imageDone = imageView.image else {return UIImage()}
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: imageView.frame.width, height: imageView.frame.height))
        
        let image = renderer.image { ctx in
            let imageRect = CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height)
            imageDone.draw(in: imageRect)
            
            let textRect = CGRect(x: 0, y: 0, width: imageView.frame.width, height: 20)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let text = "From Storm Viewer"
            let attrs: [NSAttributedString.Key:Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            let imageText = NSAttributedString(string: text, attributes: attrs)
            imageText.draw(in: textRect)
        }
        
        return image
    }
}
