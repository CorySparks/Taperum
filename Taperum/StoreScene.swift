//
//  StoreScene.swift
//  Taperum
//
//  Created by Cory Sparks on 6/10/17.
//  Copyright © 2017 The Glass House Studios. All rights reserved.
//

import SpriteKit
import UIKit


class StoreScene: SKScene{
    
    weak var scrollView: CustomScrollView!
    let moveableNode = SKNode()
    
    var Coin300IAP: SKSpriteNode!
    var BuyBtnNode300: SKSpriteNode!
    var Coin300CostLbl: SKLabelNode!
    
    var Coin1700IAP: SKSpriteNode!
    var BuyBtnNode1700: SKSpriteNode!
    var Coin1700CostLbl: SKLabelNode!

    var Coin4000IAP: SKSpriteNode!
    var BuyBtnNode4000: SKSpriteNode!
    var Coin4000CostLbl: SKLabelNode!
    
    override func didMove(to view: SKView) {
        scrollView = CustomScrollView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), scene: self, moveableNode: moveableNode, scrollDirection: .horizontal)
        scrollView.contentSize = CGSize(width: self.frame.size.width * 3, height: self.frame.size.height)
        view.addSubview(scrollView)
        
        addChild(moveableNode)
        
        //###300 coins ad
        
        self.Coin300IAP = SKSpriteNode.init(texture: SKTexture(image: #imageLiteral(resourceName: "SmallStackCoins")), size: CGSize(width: (self.frame.size.width - 10), height: (self.frame.size.height / 1.8)))
        Coin300IAP.position = CGPoint(x: 0, y: 0)
        
        self.BuyBtnNode300 = SKSpriteNode.init(texture: SKTexture(image: #imageLiteral(resourceName: "BuyBtnTexture")), size: CGSize(width: 200, height: 60))
        BuyBtnNode300.position = CGPoint(x: 0, y: -150)
        BuyBtnNode300.zPosition = 10
        BuyBtnNode300.name = "BuyBtn300"
        
        self.Coin300CostLbl = SKLabelNode(fontNamed: "Arial")
        self.Coin300CostLbl.text = "300 Coins $0.99"
        self.Coin300CostLbl.horizontalAlignmentMode = .center
        self.Coin300CostLbl.position = CGPoint(x: 0, y: -70)
        self.Coin300CostLbl.zPosition = 10
        
        moveableNode.addChild(Coin300IAP)
        Coin300IAP.addChild(BuyBtnNode300)
        Coin300IAP.addChild(Coin300CostLbl)
        
        //###1700 coins ad
        
        self.Coin1700IAP = SKSpriteNode.init(texture: SKTexture(image: #imageLiteral(resourceName: "MediumCoinStack")), size: CGSize(width: (self.frame.size.width - 10), height: (self.frame.size.height / 1.8)))
        Coin1700IAP.position = CGPoint(x: self.frame.midY + self.frame.size.width, y: 0)
        
        self.BuyBtnNode1700 = SKSpriteNode.init(texture: SKTexture(image: #imageLiteral(resourceName: "BuyBtnTexture")), size: CGSize(width: 200, height: 60))
        BuyBtnNode1700.position = CGPoint(x: 0, y: -150)
        BuyBtnNode1700.zPosition = 10
        BuyBtnNode1700.name = "BuyBtn1700"
        
        self.Coin1700CostLbl = SKLabelNode(fontNamed: "Arial")
        self.Coin1700CostLbl.text = "1700 Coins $4.99"
        self.Coin1700CostLbl.horizontalAlignmentMode = .center
        self.Coin1700CostLbl.position = CGPoint(x: 0, y: -70)
        self.Coin1700CostLbl.zPosition = 10
        
        moveableNode.addChild(Coin1700IAP)
        Coin1700IAP.addChild(BuyBtnNode1700)
        Coin1700IAP.addChild(Coin1700CostLbl)
        
        //###4000 coins ad
        
        self.Coin4000IAP = SKSpriteNode.init(texture: SKTexture(image: #imageLiteral(resourceName: "TonsCoins")), size: CGSize(width: (self.frame.size.width - 10), height: (self.frame.size.height / 1.8)))
        Coin4000IAP.position = CGPoint(x: self.frame.midY + (self.frame.size.width * 2), y: 0)
        
        self.BuyBtnNode4000 = SKSpriteNode.init(texture: SKTexture(image: #imageLiteral(resourceName: "BuyBtnTexture")), size: CGSize(width: 200, height: 60))
        BuyBtnNode4000.position = CGPoint(x: 0, y: -150)
        BuyBtnNode4000.zPosition = 10
        BuyBtnNode4000.name = "BuyBtnNode4000"
        
        self.Coin4000CostLbl = SKLabelNode(fontNamed: "Arial")
        self.Coin4000CostLbl.text = "4000 Coins $9.99"
        self.Coin4000CostLbl.horizontalAlignmentMode = .center
        self.Coin4000CostLbl.position = CGPoint(x: 0, y: -80)
        self.Coin4000CostLbl.zPosition = 10
        
        moveableNode.addChild(Coin4000IAP)
        Coin4000IAP.addChild(BuyBtnNode4000)
        Coin4000IAP.addChild(Coin4000CostLbl)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodeArray = self.nodes(at: location)
            
            if(nodeArray.first?.name == "Next"){
                let transition = SKTransition.fade(withDuration: 1.0)
                if let SecondTut = secondTut(fileNamed: "secondTut"){
                    SecondTut.scaleMode = .aspectFill
                    
                    self.view?.presentScene(SecondTut, transition: transition)
                }
                
            }
            
            if(nodeArray.first?.name == "Menu"){
                let transition = SKTransition.fade(withDuration: 1.0)
                if let menuScene = MenuScene(fileNamed: "MenuScene"){
                    menuScene.scaleMode = .aspectFill
                    
                    self.view?.presentScene(menuScene, transition: transition)
                }
                
            }
        }
    }
}
