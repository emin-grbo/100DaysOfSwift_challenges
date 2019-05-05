//
//  ViewController.swift
//  Project10
//
//  Created by roblack on 05/05/2019.
//  Copyright © 2019 roblack. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	var people = [Person]()

    @IBOutlet var authenticateBtn: UIBarButtonItem!
    
    @IBOutlet var doneBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
		super.viewDidLoad()

        KeychainWrapper.standard.set("123", forKey: "secretPassword")
        authenticate()
        
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(lockContent), name: UIApplication.didEnterBackgroundNotification, object: nil)
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return people.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell

		let person = people[indexPath.item]

		cell.name.text = person.name

		let path = getDocumentsDirectory().appendingPathComponent(person.image)
		cell.imageView.image = UIImage(contentsOfFile: path.path)

		cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
		cell.imageView.layer.borderWidth = 2
		cell.imageView.layer.cornerRadius = 3
		cell.layer.cornerRadius = 7

		return cell
	}

	@objc func addNewPerson() {
		let picker = UIImagePickerController()
		picker.allowsEditing = false
		picker.delegate = self
		present(picker, animated: true)
	}

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.originalImage] as? UIImage else { return }

		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
			try? jpegData.write(to: imagePath)
		}

		let person = Person(name: "Unknown", image: imageName)
		people.append(person)
		collectionView?.reloadData()
        savePeopleArray()
        
		dismiss(animated: true)
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let person = people[indexPath.item]

		let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
		ac.addTextField()

		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

		ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, ac] _ in
			let newName = ac.textFields![0]
			person.name = newName.text!

			self.collectionView?.reloadData()
		})

		present(ac, animated: true)
	}

	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}
    
    func savePeopleArray() {
        if let dataObject = try? JSONEncoder().encode(people) {
            KeychainWrapper.standard.set(dataObject, forKey: "peopleArray")
        } else {
            fatalError("Failed to save people array")
        }
    }
    
    func loadPeopleArray() {
        if let dataObject = KeychainWrapper.standard.data(forKey: "peopleArray") {
            do {
                people = try JSONDecoder().decode([Person].self, from: dataObject)
                print("loaded people array")
                collectionView.reloadData()
            } catch {
                print("Failed to load people array")
            }
        } else {
            people = [Person]()
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify thyself mortal!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] succes, Autherror in
                
                DispatchQueue.main.async {
                    if succes{
                        self?.loadPeopleArray()
                        self?.authenticateBtn.isEnabled = false
                        self?.doneBtn.isEnabled = true
                    } else {
                        let ac = UIAlertController(title: "Auth Failes", message: "You could not be verified pls try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry Unavailable", message: "Device not configured for biometric identification. Using password as a fallback", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] (UIAlertAction) in
                self?.presentPasswordAlert()
            })
            present(ac, animated: true)
        }
    }
    
    
    func presentPasswordAlert() {
        let ac = UIAlertController(title: "Enter your secret password", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] (alert) in
            if ac.textFields![0].text == KeychainWrapper.standard.string(forKey: "secretPassword") {
                self?.loadPeopleArray()
            } else {
                let acFail = UIAlertController(title: "Auth Failed", message: "You could not be verified please try again", preferredStyle: .alert)
                acFail.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(acFail, animated: true)
            }
        })
        present(ac, animated: true)
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        authenticate()
        doneBtn.isEnabled = true
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        savePeopleArray()
        authenticateBtn.isEnabled = true
        doneBtn.isEnabled = false
        lockContent()
    }
    
    @objc func lockContent() {
        people = [Person]()
        collectionView.reloadData()
        doneBtn.isEnabled = false
        authenticateBtn.isEnabled = true
    }
}
