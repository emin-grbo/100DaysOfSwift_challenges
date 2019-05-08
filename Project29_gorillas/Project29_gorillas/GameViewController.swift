//
//  GameViewController.swift
//  Project29_gorillas
//
//  Created by Emin Roblack on 5/6/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    
    @IBOutlet var launchBtn: UIButton!
    @IBOutlet var playerNumber: UILabel!
    
    var currentGame: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleChanged(self)
        velocityChanged(self)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        
        launchBtn.isHidden = true
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< Player One"
        } else {
            playerNumber.text = "Player Two >>>"
        }
        
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        
        launchBtn.isHidden = false
        
    }
    
    func endIt(winner: String) {
        let ac = UIAlertController(title: "Congrats!", message: "\(winner)\nwon the game!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "REMATCH", style: .default) { (UIAlertAction) in
            self.currentGame?.startNewGame()
            self.currentGame?.resetScore()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac, animated: true)
    }
}
