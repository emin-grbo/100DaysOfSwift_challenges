//
//  ViewController.swift
//  Project28_faceID
//
//  Created by Emin Roblack on 5/4/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet var doneBarBtn: UIBarButtonItem!
    @IBOutlet var secret: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        // Setting a preDefined password
        KeychainWrapper.standard.set("123", forKey: "secretPassword")
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @IBAction func doneBarBtnTapped(_ sender: Any) {
        saveSecretMessage()
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify Yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] succes, authencitacionError in
                DispatchQueue.main.async {
                    if succes {
                        self?.unlockSecretMessage()
                        self?.doneBarBtn.isEnabled = true
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
                self?.unlockSecretMessage()
                self?.doneBarBtn.isEnabled = true
            } else {
                let acFail = UIAlertController(title: "Auth Failed", message: "You could not be verified please try again", preferredStyle: .alert)
                acFail.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(acFail, animated: true)
            }
        })
        present(ac, animated: true)
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}

        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret Stuff"
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else {return}
        doneBarBtn.isEnabled = false
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
    }
    
}

