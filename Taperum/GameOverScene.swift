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
    
    var scoreLabel: SKLabelNode!
    var newGameBtnNode: SKSpriteNode!
    var menuBtnNode: SKSpriteNode!
    
    var userDefaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        self.scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "Score: \(score)"
        
        userDefaults.set(score, forKey: "Best")
        userDefaults.synchronize()
        
        self.newGameBtnNode = self.childNode(withName: "newGameBtn") as! SKSpriteNode
        self.menuBtnNode = self.childNode(withName: "menuBtn") as! SKSpriteNode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodeArray = self.nodes(at: location)
            
            if(nodeArray.first?.name == "newGameBtn"){
                let transition = SKTransition.fade(withDuration: 1.0)
                if let gameScene = GameScene(fileNamed: "GameScene"){
                    gameScene.scaleMode = .aspectFill
                    
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
