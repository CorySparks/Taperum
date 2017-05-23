//
//  GameOver.swift
//  Taperum
//
//  Created by Cory Sparks on 5/23/17.
//  Copyright © 2017 The Glass House Studios. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    //var score: Int = 0
    
    var scoreLabel: SKLabelNode!
    var newGameBtnNode: SKSpriteNode!
    //var menuBtnNode: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        self.scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        //scoreLabel.text = "\(score)"
        
        self.newGameBtnNode = self.childNode(withName: "newGameBtn") as! SKSpriteNode
        
    }
    
    //this does not work for some reason
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodeArray = self.nodes(at: location)
            
            if(nodeArray.first?.name == "newGameBtn"){
                if let gameScene = GameScene(fileNamed: "GameScene"){
                    gameScene.scaleMode = .aspectFill
                    
                    self.view?.presentScene(gameScene)
                }
                
            }
        }
    }
    
}
