//
//  GameScene.swift
//  Project26_Accelerometer_game
//
//  Created by Emin Roblack on 4/27/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import SpriteKit
import CoreMotion
import UIKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case portal = 32
    case portalExit = 64
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var level = 1
    
    var motionManager: CMMotionManager?
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
 
    override func didMove(to view: SKView) {
        loadBackground()
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        scoreLabel.name = "Score"
        addChild(scoreLabel)
        
        loadLevel()
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    
    func loadLevel() {
        if level > 3 {
            level = 1
        }
        let lines = loadLevelArray(fileName: "level\(level)", fileExtension: "txt")
        
        for (row, line) in lines.reversed().enumerated() {
            for (collumn, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * collumn) + 32, y: (64 * row) + 32)
                
                if letter == "x" {
                    // load a wall
                    loadWall(at: position)
                } else if letter == "v" {
                    // load a vortex
                    loadVortex(at: position)
                } else if letter == "s" {
                    // load a star
                    loadStar(at: position)
                } else if letter == "f" {
                    // load a final point
                    loadFinish(at: position)
                } else if letter == " "{
                    // do nothing
                } else if letter == "p" {
                    loadPortal(at: position)
                } else if letter == "e" {
                    loadPortalExit(at: position)
                } else {
                    fatalError("Unknown letter \(letter)")
                }
            }
        }
    }
    
    // MARK: - Getting the level as array of Strings ----------------------------------------------------
    func loadLevelArray(fileName: String, fileExtension: String) -> [String] {
        guard let levelURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            fatalError("Could not find level in the bundle")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not find level in the bundle")
        }
        return levelString.trimmingCharacters(in: .newlines).components(separatedBy: "\n")
    }
    //-----------------------------------------------------------------------------------------
    
    
    // MARK: - Loading level elements -------------------------------------------------------------------
    func loadWall(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    //-----------------------------------------------------------------------------------------
    func loadVortex(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        addChild(node)
    }
    //-----------------------------------------------------------------------------------------
    func loadStar(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        node.position = position
        addChild(node)
    }
    //-----------------------------------------------------------------------------------------
    func loadFinish(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        node.position = position
        addChild(node)
    }
    //-----------------------------------------------------------------------------------------
    func loadPortal(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "portal")
        node.name = "portal"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.portal.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        node.position = position
        addChild(node)
    }
    //-----------------------------------------------------------------------------------------
    func loadPortalExit(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "portalExit")
        node.name = "portalExit"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.portalExit.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        node.position = position
        addChild(node)
    }
    //-----------------------------------------------------------------------------------------
    func loadBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    //-----------------------------------------------------------------------------------------
    
    
    func createPlayer(at position: CGPoint? = CGPoint(x: 96, y: 672)) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = position!
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        guard isGameOver == false else {return}
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelData.acceleration.y * -50, dy: accelData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA == player {
            print("collide 1")
            playerColided(with: nodeB)
        } else if nodeB == player {
            print("collide 2")
            playerColided(with: nodeA)
        }
    }
    
    func playerColided(with node: SKNode) {
        
        if node.name == "vortex" {
            print("hit a vortex")
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(by: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) {
                [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            print("hit a star")
            node.removeFromParent()
            score += 1
        } else if node.name == "portal" {
            guard let otherPortal = self.childNode(withName: "portalExit") else {return}
            player.removeFromParent()
            createPlayer(at: otherPortal.position)
        } else if node.name == "finish" {
            isGameOver = true
            physicsWorld.gravity = .zero
            level += 1
            score += 100
            
            let ac = UIAlertController(title: "Well Done!", message: "Level \(level - 1) completed!\nLevel \(level) awaits!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's GO!", style: .default, handler: { [weak self] (action) in
                self?.enumerateChildNodes(withName: "//*", using: { (node, true) in
                    if node.name != "Score" {
                        node.removeFromParent()
                    }
                })
                self?.loadLevel()
                self?.createPlayer()
                self?.isGameOver = false
                self?.loadBackground()
            }))
            view?.window?.rootViewController?.present(ac, animated: true)
        }
    }
}
