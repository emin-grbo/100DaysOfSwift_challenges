//
//  ViewController.swift
//  Project50_challenge
//
//  Created by Emin Roblack on 3/24/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var imagesArray = [Images]()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func addBtnPressed(_ sender: Any) {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker,animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else {return}
    
    let imageName = UUID().uuidString
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
    
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    
    let entry = Images(name: "Unknown", image: imagePath.path)
    
    imagesArray.append(entry)
    
    dismiss(animated: true) {
      let ac = UIAlertController(title: "Name the image", message: nil, preferredStyle: .alert)
      ac.addTextField()
      ac.addAction(UIAlertAction(title: "OK", style: .default) {
        [weak self, weak ac] (alert: UIAlertAction) in
        guard let newName = ac?.textFields?[0].text else {return}
        entry.name = newName
        self?.tableView.reloadData()
      })
      self.present(ac, animated: true)
    }
    tableView.reloadData()

  }
  
  // Getting the main directory path
  func getDocumentsDirectory() -> URL {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path[0]
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return imagesArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = imagesArray[indexPath.row].name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? detailVC else {return}
    vc.selectedImage = imagesArray[indexPath.row].image
    navigationController?.pushViewController(vc, animated: true)
  }
  
}

