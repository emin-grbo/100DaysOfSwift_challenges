//
//  ViewController.swift
//  Milestone25-27
//
//  Created by Emin Roblack on 5/3/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var importBtn: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    var upperText = ""
    var lowerText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        importBtn.layer.cornerRadius = 25
        imageView.layer.cornerRadius = 5
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    func importImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        imageView.image = image
        dismiss(animated: true, completion: {
            let ac = UIAlertController(title: "ENTER TEXT IF ANY", message: nil, preferredStyle: .alert)
            
            ac.addTextField { (textfield) in
                textfield.placeholder = "Top Text"
            }
            ac.addTextField { (textfield) in
                textfield.placeholder = "Bottom Text"
            }
            
            ac.addAction(UIAlertAction(title: "DONE", style: .default){ [weak self] (UIAlertAction) in
                self?.upperText = ac.textFields![0].text ?? ""
                self?.lowerText = ac.textFields![1].text ?? ""
                self?.imageView.image = self?.addTextToImage()
            })
            self.present(ac, animated: true)
        })
    }

    @IBAction func importBtnPressed(_ sender: Any) {
        importImage()
    }
    
    func addTextToImage() -> UIImage {
        
        guard let baseImage = imageView.image else {return UIImage()}
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: imageView.frame.width, height: imageView.frame.height))
        let image = renderer.image { ctx in
            
            let rect = CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height)
            baseImage.draw(in: rect)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key:Any] = [
                // This font is a default so force unwraping.
                .font: UIFont(name: "Optima-ExtraBlack", size: 32)!,
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -3.0,
                .paragraphStyle: paragraphStyle
            ]
            
            for i in 0...1 {
                var textToPlace = ""
                var textRect = CGRect()
                if i == 0 {
                    textRect = CGRect(x: 0,
                                      y: 0,
                                      width: imageView.frame.width,
                                      height: imageView.frame.height/2)
                    textToPlace = upperText
                } else {
                    textRect = CGRect(x: 0,
                                      y: imageView.frame.height - 80,
                                      width: imageView.frame.width,
                                      height: imageView.frame.height/2)
                    textToPlace = lowerText
                }
                
                let text = NSAttributedString(string: textToPlace.uppercased(), attributes: attrs)
                UIColor.black.setStroke()
                ctx.cgContext.strokePath()
                text.draw(with: textRect, options: .usesLineFragmentOrigin, context: nil)
                imageView.contentMode = .center
            }
        }
        
        return image
    }
    
    @objc func share() {
        let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: [])
        present(vc, animated: true)
    }
    
}

