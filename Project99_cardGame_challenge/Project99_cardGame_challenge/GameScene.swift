//
//  GameScene.swift
//  Project99_cardGame_challenge
//
//  Created by Emin Roblack on 5/11/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var colors = [UIColor.red,
                  UIColor.red,
                  UIColor.blue,
                  UIColor.blue,
                  UIColor.orange,
                  UIColor.orange,
                  UIColor.black,
                  UIColor.black,
                  UIColor.cyan,
                  UIColor.cyan,
                  UIColor.magenta,
                  UIColor.magenta,
                  UIColor.brown,
                  UIColor.brown,
                  UIColor.purple,
                  UIColor.purple]
    
    var count = 0
    var completedPairs = 0
    var flips = 0
    weak var vc: GameViewController?
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "BG")
        background.zPosition = -1
        background.color = .black
        background.colorBlendFactor = 0.2
        background.blendMode = .replace
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 + 500)
        logo.size = CGSize(width: 400, height: 227)
        addChild(logo)
        
        addChild(background)
        
        colors.shuffle()
        
        for row in 0...3 {
            for col in 0...3 {
                let card = SKSpriteNode(imageNamed: "cardRed")
                card.size = CGSize(width: 150, height: 200)
                card.position = CGPoint(x: CGFloat(row * 150) + 185, y: CGFloat(col * 200) + 400)
                card.color = colors.first!
                colors.remove(at: 0)
                addChild(card)
            }
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        guard let tappedNode = nodes(at: location).first as? SKSpriteNode else {return}
        
        if tappedNode.colorBlendFactor == 0 {
            flips += 1
            count += 1
            tappedNode.name = "\(count)"
            tappedNode.run(flipFace())
        } else {
            return
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if count == 2 {
            checkColors()
            count = 0
        }
    }
    
    
    func checkColors() {
        guard let first = childNode(withName: "1") as? SKSpriteNode else {return}
        guard let second = childNode(withName: "2") as? SKSpriteNode else {return}
        
        afterDelay(0.5) {
        if first.color.description == second.color.description {
                first.isHidden = true
                second.isHidden = true
                first.removeFromParent()
                second.removeFromParent()
                self.completedPairs += 1
            self.checkEndgame()
        } else {
            first.run(self.flipBack())
            second.run(self.flipBack())
            first.name = ""
            second.name = ""
        }
    }
    }
    
    func checkEndgame() {
        if completedPairs == 8 {
            let ac = UIAlertController(title: "BRAVO", message: #"You are a force to be reckoned with\nAnd it took you "only" \#(flips) flips"#, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] action in
                self?.startNewGame()
            })
            vc?.present(ac, animated: true)
            
        }
    }
    
    func flipFace() -> SKAction {
        let scale1 = SKAction.scale(to: 1.1, duration: 0.1)
        let flip1 = SKAction.scaleX(to: 0, duration: 0.1)
        let colorize = SKAction.colorize(withColorBlendFactor: 1, duration: 0)
        let texturize = SKAction.setTexture(SKTexture(imageNamed: "card"))
        let scale2 = SKAction.scale(to: 1.1, duration: 0.1)
        let flip2 = SKAction.scaleX(to: 1, y: 1, duration: 0.2)
        return SKAction.sequence([scale1, scale2, flip1, colorize, texturize, flip2])
    }
    
    func flipBack() -> SKAction {
        let scale1 = SKAction.scale(to: 1.1, duration: 0.1)
        let flip1 = SKAction.scaleX(to: 0, duration: 0.1)
        let colorize = SKAction.colorize(withColorBlendFactor: 0, duration: 0)
        let texturize = SKAction.setTexture(SKTexture(imageNamed: "cardRed"))
        let scale2 = SKAction.scale(to: 1.1, duration: 0.1)
        let flip2 = SKAction.scaleX(to: 1, y: 1, duration: 0.2)
        return SKAction.sequence([scale1, scale2, flip1, colorize, texturize, flip2])
    }
    
    func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
    }
    
    func startNewGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        let newGame = GameScene(size: self.size)
            newGame.vc = self.vc
            self.vc?.currentGame = newGame
            
            let transition = SKTransition.fade(with: .black, duration: 2)
            self.view?.presentScene(newGame, transition: transition)
        }
    }
    
}
