//
//  MenuScene.swift
//  Taperum
//
//  Created by Cory Sparks on 5/23/17.
//  Copyright © 2017 The Glass House Studios. All rights reserved.
//

import SpriteKit

struct retardedSquare {
    var name: String
    var design: AnyObject
    var doesNotCost: Bool
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
    var BuyBtnNode: SKSpriteNode!
    var bestscoreLblNode: SKLabelNode!
    var CostLbl: SKLabelNode!
    var totalGoldLabelNode: SKLabelNode!
    var coinImg: SKShapeNode!
    var canPlay: Bool! = true
    
    var cost: Int! = 0
    
    var userDefaults = UserDefaults.standard
    var bestScore = UserDefaults.standard.integer(forKey: "Best")
    var characterChoice = UserDefaults.standard.integer(forKey: "characterChoice")
    
    var characterArray: [retardedSquare]! = [retardedSquare(name: "white", design: UIColor.white, doesNotCost: true, coins: 0), retardedSquare(name: "blue", design: UIColor.blue, doesNotCost: true, coins: 0), retardedSquare(name: "green", design: UIColor.green, doesNotCost: true, coins: 0), retardedSquare(name: "gray", design: UIColor.gray, doesNotCost: true, coins: 0), retardedSquare(name: "cyan", design: UIColor.cyan, doesNotCost: true, coins: 0), retardedSquare(name: "yellow", design: UIColor.yellow, doesNotCost: true, coins: 0), retardedSquare(name: "red", design: UIColor.red, doesNotCost: true, coins: 0) ,retardedSquare(name: "purple", design: UIColor.purple, doesNotCost: true, coins: 0), retardedSquare(name: "orange", design: UIColor.orange, doesNotCost: true, coins: 0), retardedSquare(name: "brown", design: UIColor.brown, doesNotCost: true, coins: 0), retardedSquare(name: "random", design: SKTexture(image: #imageLiteral(resourceName: "random")), doesNotCost: UserDefaults.standard.bool(forKey: "random"), coins: 50), retardedSquare(name: "mouse", design: SKTexture(image: #imageLiteral(resourceName: "mouse")), doesNotCost: UserDefaults.standard.bool(forKey: "mouse"), coins: 100), retardedSquare(name: "pizza", design: SKTexture(image: #imageLiteral(resourceName: "pizza_mindsunfold")), doesNotCost: UserDefaults.standard.bool(forKey: "pizza"), coins: 100)]
    
    var characterIndex: Int! = 0

    var totalGold: Int! = UserDefaults.standard.integer(forKey: "totalGold"){
        didSet{
            totalGoldLabelNode.text = ": \(String(totalGold))"
        }
    }
    
    override func didMove(to view: SKView) {
        characterIndex = characterChoice
        
        self.base1 = self.childNode(withName: "base1") as? SKShapeNode
        self.base2 = self.childNode(withName: "base2") as? SKShapeNode
        self.platform = self.childNode(withName: "BasePlatform") as? SKShapeNode
        
        self.StartBtnNode = self.childNode(withName: "StartBtn") as! SKSpriteNode
        self.CharacterBtnNode = self.childNode(withName: "CharacterBtn") as! SKSpriteNode
        self.BuyBtnNode = SKSpriteNode.init(texture: SKTexture(image: #imageLiteral(resourceName: "BuyBtnTexture")), size: CGSize(width: 150, height: 35))
        self.CostLbl = self.childNode(withName: "CostLbl") as? SKLabelNode
        
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
        
        if(!characterArray[characterIndex].doesNotCost){
            canPlay = false
            
            cost = characterArray[characterIndex].coins
            
            BuyBtnNode.position = CGPoint(x: 120, y: -200)
            BuyBtnNode.texture = SKTexture(image: #imageLiteral(resourceName: "BuyBtnTexture"))
            BuyBtnNode.size = CGSize(width: 150, height: 35)
            BuyBtnNode.name = "BuyBtn"
            
            self.CostLbl = SKLabelNode(fontNamed: "Arial")
            self.CostLbl.text = "Cost: \(cost!)"
            self.CostLbl.horizontalAlignmentMode = .center
            self.CostLbl.position = CGPoint(x: -120, y: -210)
            self.CostLbl.fontSize = 20
            
            addChild(CostLbl)
            addChild(BuyBtnNode)
            
            platform.fillColor = .clear
            platform.strokeColor = .gray
            platform.fillTexture = nil
            
            base1.fillColor = .gray
            base1.strokeColor = .gray
            base1.fillTexture = SKTexture(image: #imageLiteral(resourceName: "questionMark"))
            
            base2.fillColor = .gray
            base2.strokeColor = .gray
            base2.fillTexture = SKTexture(image: #imageLiteral(resourceName: "questionMark"))
        }else{
            canPlay = true
            
            if((CostLbl) != nil){
                BuyBtnNode.removeFromParent()
                CostLbl.removeFromParent()
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
            
            if(canPlay){
                if(nodeArray.first?.name == "StartBtn"){
                    if let gameScene = GameScene(fileNamed: "GameScene"){
                        gameScene.scaleMode = .aspectFill
                        gameScene.characterIndex = self.characterIndex
                        gameScene.totalGold = self.totalGold
                        
                        self.view?.presentScene(gameScene)
                    }
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
                
                if(!characterArray[characterIndex].doesNotCost){
                    canPlay = false
                    
                    cost = characterArray[characterIndex].coins
                    
                    BuyBtnNode.position = CGPoint(x: 120, y: -200)
                    BuyBtnNode.texture = SKTexture(image: #imageLiteral(resourceName: "BuyBtnTexture"))
                    BuyBtnNode.size = CGSize(width: 150, height: 35)
                    BuyBtnNode.name = "BuyBtn"
                    
                    self.CostLbl = SKLabelNode(fontNamed: "Arial")
                    self.CostLbl.text = "Cost: \(cost!)"
                    self.CostLbl.horizontalAlignmentMode = .center
                    self.CostLbl.position = CGPoint(x: -120, y: -210)
                    self.CostLbl.fontSize = 20
                    
                    addChild(CostLbl)
                    addChild(BuyBtnNode)
                    
                    platform.fillColor = .clear
                    platform.strokeColor = .gray
                    platform.fillTexture = nil
                    
                    base1.fillColor = .gray
                    base1.strokeColor = .gray
                    base1.fillTexture = SKTexture(image: #imageLiteral(resourceName: "questionMark"))
                    
                    base2.fillColor = .gray
                    base2.strokeColor = .gray
                    base2.fillTexture = SKTexture(image: #imageLiteral(resourceName: "questionMark"))
                }else{
                    canPlay = true
                    
                    if((CostLbl) != nil){
                        BuyBtnNode.removeFromParent()
                        CostLbl.removeFromParent()
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
            
            if(nodeArray.first?.name == "BuyBtn"){
                //the only problem with this that i can tell is that when they close the app and re-run it, the
                //texture is locked again
                if(characterArray[characterIndex].coins! <= totalGold){
                    totalGold = totalGold - characterArray[characterIndex].coins!
                    userDefaults.set(totalGold, forKey: "totalGold")
                    userDefaults.synchronize()
                    
                    userDefaults.set(true, forKey: characterArray[characterIndex].name)
                    userDefaults.synchronize()
                    
                    BuyBtnNode.removeFromParent()
                    CostLbl.removeFromParent()
                    
                    characterArray[characterIndex].doesNotCost = true
                    canPlay = true
                    
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

}
