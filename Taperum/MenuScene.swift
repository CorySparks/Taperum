//
//  MenuScene.swift
//  Taperum
//
//  Created by Cory Sparks on 5/23/17.
//  Copyright © 2017 The Glass House Studios. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    //This scene is just the start button and the character button
    
    private var base1 : SKShapeNode!
    private var base2 : SKShapeNode!
    private var platform : SKShapeNode!
    
    public var baseSize : CGFloat!
    
    var StartBtnNode: SKSpriteNode!
    var CharacterBtnNode: SKSpriteNode!
    var bestscoreLblNode: SKLabelNode!
    
    var userDefaults = UserDefaults.standard
    var bestScore = UserDefaults.standard.integer(forKey: "Best")
    var characterChoice = UserDefaults.standard.integer(forKey: "characterChoice")
    
    var characterArray: [UIColor]! = [.white, .blue, .green, .gray, .cyan, .yellow, .red, .purple, .orange, .brown]
    var characterIndex: Int! = 0
    
    override func didMove(to view: SKView) {
        characterIndex = characterChoice

        self.base1 = self.childNode(withName: "base1") as? SKShapeNode
        self.base2 = self.childNode(withName: "base2") as? SKShapeNode
        self.platform = self.childNode(withName: "BasePlatform") as? SKShapeNode
        
        self.StartBtnNode = self.childNode(withName: "StartBtn") as! SKSpriteNode
        self.CharacterBtnNode = self.childNode(withName: "CharacterBtn") as! SKSpriteNode
        
        baseSize = (self.size.width + self.size.height) * 0.05
        
        self.bestscoreLblNode = SKLabelNode(fontNamed: "Arial")
        self.bestscoreLblNode.text = "Best: \(String(bestScore))"
        self.bestscoreLblNode.horizontalAlignmentMode = .center
        self.bestscoreLblNode.position = CGPoint(x: 0, y: -50)
        addChild(bestscoreLblNode)
        
        self.platform = SKShapeNode.init(rectOf: CGSize.init(width: self.size.width, height: (self.size.height / 2) / 2))
        if let platform = self.platform {
            platform.fillColor = characterArray[characterIndex]
            platform.strokeColor = characterArray[characterIndex]
            platform.position.y = (self.size.height / -2)
        }
        
        self.base1 = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        if let base1 = self.base1 {
            base1.fillColor = characterArray[characterIndex]
            base1.strokeColor = characterArray[characterIndex]
            base1.position.y = (platform.position.y) / 2 - baseSize - 10
        }
        
        self.base2 = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        if let base2 = self.base2 {
            base2.fillColor = characterArray[characterIndex]
            base2.strokeColor = characterArray[characterIndex]
            base2.position.y =  base1.position.y + baseSize
        }
        
        self.addChild(platform)
        self.addChild(base1)
        self.addChild(base2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodeArray = self.nodes(at: location)
            
            if(nodeArray.first?.name == "StartBtn"){
                if let gameScene = GameScene(fileNamed: "GameScene"){
                    gameScene.scaleMode = .aspectFill
                    gameScene.characterIndex = self.characterIndex
                    
                    self.view?.presentScene(gameScene)
                }
            }
            
            if(nodeArray.first?.name == "CharacterBtn"){
                if(characterIndex != characterArray.count - 1){
                    characterIndex? += 1
                }else{
                    characterIndex = 0
                }
                userDefaults.set(characterIndex, forKey: "characterChoice")
                userDefaults.synchronize()
                
                base1.fillColor = characterArray[characterIndex]
                base1.strokeColor = characterArray[characterIndex]
                base2.fillColor = characterArray[characterIndex]
                base2.strokeColor = characterArray[characterIndex]
                platform.fillColor = characterArray[characterIndex]
                platform.strokeColor = characterArray[characterIndex]
            }
        }
    }

}
