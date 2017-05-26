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
    private var LorR : String!
    private var createTime : Double! = 0.75
    
    public var baseSize : CGFloat!
    public var isGameOver : Bool = false
    
    var characterIndex : Int!
    var scoreLblNode: SKLabelNode!
    var score: Int = 0{
        didSet{
            scoreLblNode.text = "\(score)"
        }
    }
    
    let menuScene = MenuScene(fileNamed: "MenuScene")!
        
    override func didMove(to view: SKView) {
        //###start setup###
        self.base1 = self.childNode(withName: "base1") as? SKShapeNode
        self.base2 = self.childNode(withName: "base2") as? SKShapeNode
        self.platform = self.childNode(withName: "BasePlatform") as? SKShapeNode
        self.scoreLblNode = self.childNode(withName: "scoreLbl") as? SKLabelNode
        
        baseSize = (self.size.width + self.size.height) * 0.05
        
        self.scoreLblNode = SKLabelNode(fontNamed: "Arial")
        self.scoreLblNode.text = "0"
        self.scoreLblNode.horizontalAlignmentMode = .center
        self.scoreLblNode.position = CGPoint(x: 0, y: 300)
        camera?.addChild(scoreLblNode)
        
        self.platform = SKShapeNode.init(rectOf: CGSize.init(width: self.size.width, height: (self.size.height / 2) / 2))
        if let platform = self.platform {
            platform.fillColor = menuScene.characterArray[characterIndex]
            platform.strokeColor = menuScene.characterArray[characterIndex]
            platform.position.y = (self.size.height / -2)
        }
        
        self.base1 = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        if let base1 = self.base1 {
            base1.fillColor = menuScene.characterArray[characterIndex]
            base1.strokeColor = menuScene.characterArray[characterIndex]
            base1.position.y =  (platform.position.y) / 2 - baseSize - 10
        }
        
        self.base2 = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        if let base2 = self.base2 {
            base2.fillColor = menuScene.characterArray[characterIndex]
            base2.strokeColor = menuScene.characterArray[characterIndex]
            base2.position.y =  base1.position.y + baseSize
        }

        self.addChild(platform)
        self.addChild(base1)
        self.addChild(base2)
        //###end setup###
        
        //timer to make the squares, to make the creation time fast over time we make the repeat false
        squareTimer = Timer.scheduledTimer(timeInterval: createTime, target: self, selector: #selector(addSquare), userInfo: nil, repeats: false)
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
        //changing square creation speed over time
        if(createTime >= 0.40){
            createTime! -= 0.005
            print(createTime)
        }
        
        //starting the square in the right spot
        if(squareNodeStack.count > 0){
            lastSquarePosition = squareNodeStack[squareNodeStack.count-1]!.position
        }else{
            lastSquarePosition = base2.position
        }
        
        //two random posistions, left or right
        randomPos = [lastSquarePosition.x - baseSize, lastSquarePosition.x + baseSize]
        if(squareNodeStack.count > 0){
            //had to add this or else it would try and - 1 from array and crash the games if the player loses
            if(isGameOver == false){
                //detects if the square is getting close to the right side of screen
                if(squareNodeStack[squareNodeStack.count-1]!.position.x > (view?.frame.maxX)! - 250){
                    //makes square go left
                    randomIndex = 0
                //detects if the square is getting close to the left side of screen
                }else if(squareNodeStack[squareNodeStack.count-1]!.position.x < (view?.frame.minX)! - 150){
                    //makes square go right
                    randomIndex = 1
                }else{
                    //grabs random pos
                    randomIndex = Int(arc4random_uniform(UInt32(randomPos.count)))
                }
            }else{
                randomIndex = 0
            }
        }else{
            randomIndex = Int(arc4random_uniform(UInt32(randomPos.count)))
        }
        
        
        var square: SKShapeNode!
        
        square =  self.childNode(withName: "Square") as? SKShapeNode
        
        square = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        if let s = square {
            //grabs the color the character has picked in the menuScene
            s.fillColor = menuScene.characterArray[characterIndex]
            s.strokeColor = menuScene.characterArray[characterIndex]
        }
        
        //so we can add points easily and tell what side the square was on to determine the touch
        if(randomIndex == 0){
            LorR = "left"
        }else{
            LorR = "right"
        }
        
        square.position = CGPoint(x: randomPos[randomIndex], y: lastSquarePosition.y + baseSize)
        
        self.addChild(square!)
        self.squareNodeStack.append(square)
        if(squareNodeStack.count > 3){
            updateCamera()
        }
        //so that it calls itself and increases createTime over time
        squareTimer = Timer.scheduledTimer(timeInterval: createTime, target: self, selector: #selector(addSquare), userInfo: nil, repeats: false)
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
        
        for touch in touches {
            let location = touch.location(in: self)
            
            //detect left side of screen touch
            if(location.x < 0){
                //if not the left side of screen call game over scene
                if(LorR != "left"){
                    isGameOver = true
                    let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                    
                    let gameOver = GameOverScene(fileNamed: "GameOverScene")!
                    gameOver.score = self.score
                    self.view?.presentScene(gameOver, transition: transition)
                }else{
                    //if you tapped the correct side ads a point
                    score += 1
                }
            }
            else{
                if(LorR != "right"){
                    isGameOver = true
                    let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                    
                    let gameOver = GameOverScene(fileNamed: "GameOverScene")!
                    gameOver.score = self.score
                    self.view?.presentScene(gameOver, transition: transition)
                }else{
                    score += 1
                }
            }
        }
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
