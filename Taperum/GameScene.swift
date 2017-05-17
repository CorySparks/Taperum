//
//  GameScene.swift
//  Taperum
//
//  Created by Cory Sparks on 5/11/17.
//  Copyright © 2017 The Glass House Studios. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var base1 : SKShapeNode!
    private var base2 : SKShapeNode!
    private var platform : SKShapeNode!
    private var squareNodeStack : [SKShapeNode?] = []
    private var squareTimer : Timer!
    
    public var baseSize : CGFloat!
        
    override func didMove(to view: SKView) {
        
        NSLog("CALLED DID MOVE")
        
        self.base1 = self.childNode(withName: "base1") as? SKShapeNode
        self.base2 = self.childNode(withName: "base2") as? SKShapeNode
        self.platform = self.childNode(withName: "BasePlatform") as? SKShapeNode
        
        baseSize = (self.size.width + self.size.height) * 0.05
        
        self.platform = SKShapeNode.init(rectOf: CGSize.init(width: self.size.width, height: (self.size.height / 2) / 2))
        if let platform = self.platform {
            platform.fillColor = .white
            platform.strokeColor = .white
            platform.position.y = (self.size.height / -2)
        }
        
        self.base1 = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        if let base1 = self.base1 {
            base1.fillColor = .white
            base1.strokeColor = .white
            base1.position.y =  (platform.position.y) / 2 - baseSize - 10
        }
        
        self.base2 = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        if let base2 = self.base2 {
            base2.fillColor = .white
            base2.strokeColor = .white
            base2.position.y =  base1.position.y + baseSize
        }

        self.addChild(platform)
        self.addChild(base1)
        self.addChild(base2)
        
        squareTimer =  Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addSquare), userInfo: nil, repeats: true)
    }
    
    func addSquare(){
        var square: SKShapeNode!
        
        square =  self.childNode(withName: "Square") as? SKShapeNode
        
        square = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        if let s = square {
            s.fillColor = .red
            s.strokeColor = .red
        }
        
        let randomSquarePos = GKRandomDistribution(lowestValue: Int(base2.position.x - baseSize), highestValue: Int(base2.position.x + baseSize))
        
        let position = CGFloat(randomSquarePos.nextInt())
        
        square.position = CGPoint(x: position, y: base2.position.y + baseSize)
        
        self.addChild(square!)
        self.squareNodeStack.append(square)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
