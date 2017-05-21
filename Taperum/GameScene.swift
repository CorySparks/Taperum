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
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if(squareNodeStack.count > 0){
            if let camera = camera {
                if (!camera.contains(squareNodeStack[0]!)){
                    squareNodeStack[0]!.removeFromParent()
                    squareNodeStack.remove(at: 0)
                }
            }
        }
    }
    
    func addSquare(){
        var lastSquarePosition: CGPoint
        var randomPos: [CGFloat]
        var randomIndex: Int
        
        if(squareNodeStack.count > 0){
            lastSquarePosition = squareNodeStack[squareNodeStack.count-1]!.position
        }else{
            lastSquarePosition = base2.position
        }
        
        randomPos = [lastSquarePosition.x - baseSize, lastSquarePosition.x + baseSize]
        if(squareNodeStack.count > 0){
            if(squareNodeStack[squareNodeStack.count-1]!.position.x > (view?.frame.maxX)! - 150){
                //taks the width of screen and - 150 then it goes right if close to edge
                print(">")
                randomIndex = 0
            }else if(squareNodeStack[squareNodeStack.count-1]!.position.x < (view?.frame.minX)! - 250){
                //taks the width of screen and - 250 then it goes left if close to edge
                //idk why the "-" are different
                print("<")
                randomIndex = 1
            }else{
                randomIndex = Int(arc4random_uniform(UInt32(randomPos.count)))
            }
        }else{
            randomIndex = Int(arc4random_uniform(UInt32(randomPos.count)))
        }
        
        
        var square: SKShapeNode!
        
        square =  self.childNode(withName: "Square") as? SKShapeNode
        
        square = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        if let s = square {
            s.fillColor = .white
            s.strokeColor = .white
        }
        
        square.position = CGPoint(x: randomPos[randomIndex], y: lastSquarePosition.y + baseSize)
        
        self.addChild(square!)
        self.squareNodeStack.append(square)
        if(squareNodeStack.count > 3){
            updateCamera()
        }
    }
    
    func updateCamera() {
        if let camera = camera {
            camera.position = CGPoint(x: 0, y: self.squareNodeStack[self.squareNodeStack.count-1]!.position.y)
        }
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
    
}
