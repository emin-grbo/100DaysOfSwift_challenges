//
//  GameScene.swift
//  Day66_challenge
//
//  Created by Emin Roblack on 4/8/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background: SKSpriteNode!
    let vehicles = ["police", "racer", "truck", "bike"]
    
    var gametTimer: Timer!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var roundsLabel: SKLabelNode!
    var rounds = 6 {
        didSet{
            roundsLabel.text = "Rounds Left: \(rounds)"
        }
    }

    var reloadLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        background = SKSpriteNode(imageNamed: "stage")
        background.blendMode = .replace
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = .zero
        background.size = CGSize(width: frame.size.width, height: frame.size.height)
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Kefa")
        scoreLabel.fontSize = 45
        scoreLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height - 100)
        scoreLabel.horizontalAlignmentMode = .center
        addChild(scoreLabel)
        score = 0
        
        roundsLabel = SKLabelNode(fontNamed: "Kefa")
        roundsLabel.fontSize = 35
        roundsLabel.position = CGPoint(x: 100, y: 50)
        roundsLabel.horizontalAlignmentMode = .left
        addChild(roundsLabel)
        rounds = 6
        
        reloadLabel = SKLabelNode(fontNamed: "Kefa")
        reloadLabel.fontSize = 35
        reloadLabel.text = "RELOAD"
        reloadLabel.position = CGPoint(x: frame.size.width - 100, y: 50)
        reloadLabel.horizontalAlignmentMode = .right
        reloadLabel.alpha = 0.5
        reloadLabel.name = "reload"
        addChild(reloadLabel)
        
        gametTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -1200 || node.position.x > frame.size.width + 200 {
                node.removeFromParent()
            }
        }
    }
    
    
    @objc func createEnemy() {
        
        let frameSize = Int(frame.size.width)
        let height = Int.random(in: 200...1300)
        let direction = Int.random(in: frameSize...frameSize+200)
        
        guard let randomEnemy = vehicles.randomElement() else {return}
        let vehicle = SKSpriteNode(imageNamed: randomEnemy)
        
        vehicle.physicsBody = SKPhysicsBody(texture: vehicle.texture!, size: vehicle.size)
        vehicle.physicsBody?.linearDamping = 0
        vehicle.physicsBody?.contactTestBitMask = 1
        
        if direction.isMultiple(of: 5){
            vehicle.position = CGPoint(x: direction, y: height)
            vehicle.physicsBody?.velocity = CGVector(dx: (direction * -1 - 200), dy: 0)
        } else {
            vehicle.position = CGPoint(x: (direction * -1), y: height)
            vehicle.physicsBody?.velocity = CGVector(dx: direction - 200, dy: 0)
            vehicle.xScale = -1
        }
        
        if randomEnemy == "police" {
            vehicle.name = "police"
        } else {
            vehicle.name = "enemy"
        }
        addChild(vehicle)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        guard let touchedObject = self.nodes(at: location).first else {return}
        
        if rounds <= 1 && touchedObject.name != "reload" {
            rounds = 0
            reloadLabel.alpha = 1
            return
        }
        rounds -= 1
        
        if touchedObject.name == "enemy"{
            score += 10
            killNode(node: touchedObject)
            explosion(location: touchedObject.position)
        } else if touchedObject.name == "police" {
            score -= 20
        } else if touchedObject.name == "reload" {
            rounds = 6
            reloadLabel.alpha = 0.5
        }
    }
    
    
    func killNode(node: SKNode){
        node.removeFromParent()
    }
    
    
    func explosion(location: CGPoint) {
        guard let emmiter = SKEmitterNode(fileNamed: "explosion") else {return}
        emmiter.position = location
        addChild(emmiter)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
       explosion(location: contact.contactPoint)
        contact.bodyA.node?.removeFromParent()
        contact.bodyB.node?.removeFromParent()
    }
}
