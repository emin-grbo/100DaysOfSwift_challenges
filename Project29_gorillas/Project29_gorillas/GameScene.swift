//
//  GameScene.swift
//  Project29_gorillas
//
//  Created by Emin Roblack on 5/6/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var buildings = [BuildingNode]()
    
    weak var viewController: GameViewController?
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var p1score = 0 {
        didSet {
            scoreLabel.text = "\(p1score) : \(p2score)"
        }
    }
    
    var p2score = 0 {
        didSet {
            scoreLabel.text = "\(p1score) : \(p2score)"
        }
    }
    
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var windLabel = SKLabelNode(fontNamed: "Chalkduster")

    var currentPlayer = 1
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        scoreLabel.position = CGPoint(x: scene!.frame.width/2, y: view.frame.height - 160)
        scoreLabel.zPosition = 2
        scoreLabel.text = "\(p1score) : \(p2score)"
        scoreLabel.horizontalAlignmentMode = .center
    
        let wind = Double.random(in: -1...1)
        windLabel.position = CGPoint(x: 24, y: view.frame.height - 160)
        windLabel.zPosition = 2
        
        var windText: String {
            if wind > 0 {
                return "WIND >> \(String(format: "%.2f", wind * 10))"
            } else {
                return "WIND << \(String(format: "%.2f", wind * -10))"
            }
        }
        
        windLabel.text = windText
        
        
        windLabel.horizontalAlignmentMode = .left
        
        physicsWorld.gravity = CGVector(dx: -1, dy: -9.8)
        addChild(scoreLabel)
        addChild(windLabel)
        
        
        
        createBuildings()
        createPlayers()
        
        physicsWorld.contactDelegate = self
       
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            
            currentX += size.width + 2
            
            let building = BuildingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width/2), y: size.height/2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    
    func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10
        let radians = deg2rad(degrees: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width/2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm,pause,lowerArm])
            player1.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm,pause,lowerArm])
            player2.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width/2)
        
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + (player1Building.size.height + player1.size.height)/2)
        
        addChild(player1)
        
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width/2)
        
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + (player2Building.size.height + player2.size.height)/2)
        
        addChild(player2)
    }
    
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * .pi / 180
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        guard let firstNode = firstBody.node else {return}
        guard let secondNode = secondBody.node else {return}
        
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player1" {
            destroy(player: player1)
            p2score += 1
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
            destroy(player: player2)
            p1score += 1
        }
    }
    
    func destroy(player: SKSpriteNode) {
        
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        if p1score == 3 || p2score == 3 {
            if p1score > p2score {
                viewController?.endIt(winner: "Player 1")
            } else {
                viewController?.endIt(winner: "Player 2")
            }
        } else {
            startNewGame()
        }
    }
    
    func resetScore() {
        p1score = 0
        p2score = 0
    }
    
    func startNewGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController?.currentGame = newGame
            
            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer
            newGame.p1score = self.p1score
            newGame.p2score = self.p2score
            
            let transition = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transition)
        }
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else {return}
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBulding") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        changePlayer()
    }
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        viewController?.activatePlayer(number: currentPlayer)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else {return}
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
   
}
