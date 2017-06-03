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
    private var square: SKShapeNode!
    private var coinSquare: SKShapeNode!
    private var LorR : String!
    private var createTime : Double! = 0.75
    private var doesNeedTap = false
    
    public var baseSize : CGFloat!
    public var isGameOver : Bool = false
    public var wasGold: Bool = false
    
    var userDefaults = UserDefaults.standard
    var characterIndex : Int!
    var scoreLblNode: SKLabelNode!
    var goldLblNode: SKLabelNode!
    var coinImg: SKShapeNode!
    
    var score: Int = 0{
        didSet{
            scoreLblNode.text = "Score: \(score)"
        }
    }
    var gold: Int = 0{
        didSet{
            goldLblNode.text = ": \(gold)"
        }
    }
    
    var totalGold: Int! = 0
    
    let menuScene = MenuScene(fileNamed: "MenuScene")!
        
    override func didMove(to view: SKView) {
        userDefaults.set(totalGold, forKey: "totalGold")
        userDefaults.synchronize()
        
        print("gameScene totalgold : \(totalGold)")
        //###start setup###
        self.base1 = self.childNode(withName: "base1") as? SKShapeNode
        self.base2 = self.childNode(withName: "base2") as? SKShapeNode
        self.platform = self.childNode(withName: "BasePlatform") as? SKShapeNode
        self.scoreLblNode = self.childNode(withName: "scoreLbl") as? SKLabelNode
        self.goldLblNode = self.childNode(withName: "goldCoins") as? SKLabelNode
        self.coinImg = self.childNode(withName: "coingImg") as? SKShapeNode
        
        baseSize = (self.size.width + self.size.height) * 0.05
        
        self.scoreLblNode = SKLabelNode(fontNamed: "Arial")
        self.scoreLblNode.text = "Score: 0"
        self.scoreLblNode.horizontalAlignmentMode = .center
        self.scoreLblNode.position = CGPoint(x: -135, y: 300)
        camera?.addChild(scoreLblNode)
        
        self.goldLblNode = SKLabelNode(fontNamed: "Arial")
        self.goldLblNode.text = ": 0"
        self.goldLblNode.horizontalAlignmentMode = .center
        self.goldLblNode.position = CGPoint(x: 180, y: 300)
        
        self.coinImg = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        if let coinImg = self.coinImg {
            coinImg.fillColor = .white
            coinImg.strokeColor = .clear
            coinImg.fillTexture = SKTexture(image: #imageLiteral(resourceName: "coinGold"))
            coinImg.position = CGPoint(x: 145, y: 310)
        }
        
        camera?.addChild(coinImg)
        camera?.addChild(goldLblNode)
        
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
            //refrence to when i want to add textures, fyi fill color needs to be set to .white so the image is visable
            //or else the images doesnt show up
            //base1.fillTexture = SKTexture(image: #imageLiteral(resourceName: "random"))
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
        guard !doesNeedTap else {
            gameOver()
            return
        }
        guard !isGameOver else {
            return
        }
        var lastSquarePosition: CGPoint
        var randomPos: [CGFloat]
        var randomIndex: Int
        //changing square creation speed over time
        if(createTime >= 0.40){
            createTime! -= 0.005
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
        
        square =  self.childNode(withName: "Square") as? SKShapeNode
        
        square = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        if let s = square {
            //grabs the color the character has picked in the menuScene
            s.fillColor = menuScene.characterArray[characterIndex]
            s.strokeColor = menuScene.characterArray[characterIndex]
        }
        
        coinSquare =  self.childNode(withName: "coinSquare") as? SKShapeNode
        
        coinSquare = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        if let cs = coinSquare {
            //grabs the color the character has picked in the menuScene
            cs.fillColor = .white
            cs.strokeColor = menuScene.characterArray[characterIndex]
            cs.fillTexture = SKTexture(image: #imageLiteral(resourceName: "coinGold"))
        }
        
        //so we can add points easily and tell what side the square was on to determine the touch
        if(randomIndex == 0){
            LorR = "left"
        }else{
            LorR = "right"
        }
        
        if(arc4random_uniform(100) > 10){
            square.position = CGPoint(x: randomPos[randomIndex], y: lastSquarePosition.y + baseSize)
            self.addChild(square!)
            self.squareNodeStack.append(square)
            wasGold = false
        }else{
            coinSquare.position = CGPoint(x: randomPos[randomIndex], y: lastSquarePosition.y + baseSize)
            self.addChild(coinSquare!)
            self.squareNodeStack.append(coinSquare)
            wasGold = true
        }
        doesNeedTap = true
        if(squareNodeStack.count > 3){
            updateCamera()
        }
        
        /*idk how i like this
        if let spark = SKEmitterNode(fileNamed: "MyParticle.sks") {
            spark.position = square.position
            spark.particleLifetime = 1.0
            self.run(SKAction.wait(forDuration: 0.80)){
                spark.removeFromParent()
            }
            spark.particleScale = 0.3
            addChild(spark)
        }
        */
        
        //so that it calls itself and increases createTime over time
        if(!isGameOver){
            squareTimer = Timer.scheduledTimer(timeInterval: createTime, target: self, selector: #selector(addSquare), userInfo: nil, repeats: false)
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
    
    private func gameOver(){
        isGameOver = true
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        
        let gameOver = GameOverScene(fileNamed: "GameOverScene")!
        gameOver.score = self.score
        gameOver.characterIndex = self.characterIndex
        gameOver.gold = self.gold
        let newTotal = totalGold + gold
        userDefaults.set(newTotal, forKey: "totalGold")
        userDefaults.synchronize()
        self.view?.presentScene(gameOver, transition: transition)
    }
    
    private func processGoodTap(){
        guard doesNeedTap else {
            // expert mode this can call end game
            return
        }
        if(wasGold){
            wasGold = false
            score += 1
            gold += 1
            self.run(SKAction.playSoundFileNamed("coinGrabSound.wav", waitForCompletion: false))
        }else{
            self.run(SKAction.playSoundFileNamed("tapSound.wav", waitForCompletion: false))
            score += 1
        }
        doesNeedTap = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            //detect left side of screen touch
            if(location.x < 0){
                //if not the left side of screen call game over scene
                if(LorR != "left"){
                    gameOver()
                }else{
                    //if you tapped the correct side adds a point
                    processGoodTap()
                }
            }
            else{
                if(LorR != "right"){
                    gameOver()
                }else{
                    processGoodTap()
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
