//
//  MenuScene.swift
//  Taperum
//
//  Created by Cory Sparks on 5/23/17.
//  Copyright © 2017 The Glass House Studios. All rights reserved.
//

import SpriteKit

struct retardedSquare {
    var design: AnyObject
    var doesCost: Bool
    var coins: Int?
}

class MenuScene: SKScene {
    //This scene is just the start button and the character button
    
    private var base1 : SKShapeNode!
    private var base2 : SKShapeNode!
    private var platform : SKShapeNode!
    
    public var baseSize : CGFloat!
    
    var StartBtnNode: SKSpriteNode!
    var CharacterBtnNode: SKSpriteNode!
    var bestscoreLblNode: SKLabelNode!
    var totalGoldLabelNode: SKLabelNode!
    var coinImg: SKShapeNode!
    
    var userDefaults = UserDefaults.standard
    var bestScore = UserDefaults.standard.integer(forKey: "Best")
    var characterChoice = UserDefaults.standard.integer(forKey: "characterChoice")
    //.blue, .green, .gray, .cyan, .yellow, .red, .purple, .orange, .brown
    var characterArray: [retardedSquare]! = [retardedSquare(design: UIColor.white, doesCost: false, coins:nil), retardedSquare(design: UIColor.blue, doesCost: false, coins:nil), retardedSquare(design: UIColor.green, doesCost: false, coins:nil), retardedSquare(design: UIColor.gray, doesCost: false, coins:nil), retardedSquare(design: UIColor.cyan, doesCost: false, coins:nil), retardedSquare(design: UIColor.yellow, doesCost: false, coins:nil), retardedSquare(design: UIColor.red, doesCost: false, coins:nil) ,retardedSquare(design: UIColor.purple, doesCost: false, coins:nil), retardedSquare(design: UIColor.orange, doesCost: false, coins:nil), retardedSquare(design: UIColor.brown, doesCost: false, coins:nil), retardedSquare(design: SKTexture(image: #imageLiteral(resourceName: "random")), doesCost: true, coins: 50)]
    
    var characterIndex: Int! = 0
    var totalGold: Int! = UserDefaults.standard.integer(forKey: "totalGold")
    
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
        
        self.coinImg = SKShapeNode.init(rectOf: CGSize.init(width: 60, height: 60))
        if let coinImg = self.coinImg {
            coinImg.fillColor = .white
            coinImg.strokeColor = .clear
            coinImg.fillTexture = SKTexture(image: #imageLiteral(resourceName: "coinGold"))
            coinImg.position = CGPoint(x: -30, y: -90)
        }
        
        self.totalGoldLabelNode = SKLabelNode(fontNamed: "Arial")
        self.totalGoldLabelNode.text = ": \(String(totalGold))"
        self.totalGoldLabelNode.horizontalAlignmentMode = .center
        self.totalGoldLabelNode.position = CGPoint(x: 15, y: -100)
        addChild(coinImg)
        addChild(totalGoldLabelNode)
        
        self.platform = SKShapeNode.init(rectOf: CGSize.init(width: self.size.width, height: (self.size.height / 2) / 2))
        self.base1 = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        self.base2 = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        
        switch characterArray[characterIndex!].design{
        case is UIColor:
            platform.fillColor = characterArray[characterIndex].design as! UIColor
            platform.strokeColor = characterArray[characterIndex].design as! UIColor
            platform.fillTexture = nil
            
            base1.fillColor = characterArray[characterIndex].design as! UIColor
            base1.strokeColor = characterArray[characterIndex].design as! UIColor
            base1.fillTexture = nil
            
            base2.fillColor = characterArray[characterIndex].design as! UIColor
            base2.strokeColor = characterArray[characterIndex].design as! UIColor
            base2.fillTexture = nil
            break
        case is SKTexture:
            platform.fillColor = .white
            platform.strokeColor = .clear
            platform.fillTexture = characterArray[characterIndex].design as? SKTexture
            
            base1.fillColor = .white
            base1.strokeColor = .clear
            base1.fillTexture = characterArray[characterIndex].design as? SKTexture
            
            base2.fillColor = .white
            base2.strokeColor = .clear
            base2.fillTexture = characterArray[characterIndex].design as? SKTexture
            break
        default:
            // hmm
            break
        }
        
        platform.position.y = (self.size.height / -2)
        base1.position.y = (platform.position.y) / 2 - baseSize - 6
        base2.position.y =  base1.position.y + baseSize
        
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
                    gameScene.totalGold = self.totalGold
                    
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
                
                if (characterArray[characterIndex].doesCost){
                    //...
                }
                
                switch characterArray[characterIndex!].design{
                case is UIColor:
                    platform.fillColor = characterArray[characterIndex].design as! UIColor
                    platform.strokeColor = characterArray[characterIndex].design as! UIColor
                    platform.fillTexture = nil
                    
                    base1.fillColor = characterArray[characterIndex].design as! UIColor
                    base1.strokeColor = characterArray[characterIndex].design as! UIColor
                    base1.fillTexture = nil
                    
                    base2.fillColor = characterArray[characterIndex].design as! UIColor
                    base2.strokeColor = characterArray[characterIndex].design as! UIColor
                    base2.fillTexture = nil
                    break
                case is SKTexture:
                    platform.fillColor = .white
                    platform.strokeColor = .clear
                    platform.fillTexture = characterArray[characterIndex].design as? SKTexture
                    
                    base1.fillColor = .white
                    base1.strokeColor = .clear
                    base1.fillTexture = characterArray[characterIndex].design as? SKTexture
                    
                    base2.fillColor = .white
                    base2.strokeColor = .clear
                    base2.fillTexture = characterArray[characterIndex].design as? SKTexture
                    break
                default:
                    // hmm
                    break
                }
            }
        }
    }

}
