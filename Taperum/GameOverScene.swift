//
//  GameOver.swift
//  Taperum
//
//  Created by Cory Sparks on 5/23/17.
//  Copyright © 2017 The Glass House Studios. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var score: Int = 0
    var gold: Int = 0
    var characterIndex: Int!
    
    var scoreLabel: SKLabelNode!
    var goldLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!
    var newGameBtnNode: SKSpriteNode!
    var menuBtnNode: SKSpriteNode!
    
    var userDefaults = UserDefaults.standard
    
    var totalGold = UserDefaults.standard.integer(forKey: "totalGold")
    
    override func didMove(to view: SKView) {
        self.scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "Score: \(score)"
        
        self.goldLabel = self.childNode(withName: "goldLabel") as! SKLabelNode
        goldLabel.text = "Earned: \(gold)"
        
        let menuScene = MenuScene(fileNamed: "MenuScene")
        let bestScore = menuScene?.bestScore
        var newBest = bestScore
        if(score > (bestScore)!){
            newBest = score
            userDefaults.set(score, forKey: "Best")
            userDefaults.synchronize()
        }
        
        self.bestScoreLabel = self.childNode(withName: "bestScoreLabel") as! SKLabelNode
        bestScoreLabel.text = "Best: \((newBest)!)"
        
        self.newGameBtnNode = self.childNode(withName: "newGameBtn") as! SKSpriteNode
        self.menuBtnNode = self.childNode(withName: "menuBtn") as! SKSpriteNode
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodeArray = self.nodes(at: location)
            
            if(nodeArray.first?.name == "newGameBtn"){
                let transition = SKTransition.fade(withDuration: 1.0)
                if let gameScene = GameScene(fileNamed: "GameScene"){
                    gameScene.scaleMode = .aspectFill
                    gameScene.characterIndex = self.characterIndex
                    gameScene.totalGold = self.totalGold + self.gold
                    
                    self.view?.presentScene(gameScene, transition: transition)
                }
                
            }
            
            if(nodeArray.first?.name == "menuBtn"){
                let transition = SKTransition.fade(withDuration: 1.0)
                if let menuScene = MenuScene(fileNamed: "MenuScene"){
                    menuScene.scaleMode = .aspectFill
                    
                    self.view?.presentScene(menuScene, transition: transition)
                }
                
            }
        }
    }
    
}
