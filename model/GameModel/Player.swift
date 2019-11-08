//
//  Player.swift
//  JumperDude
//
//  Created by pro on 7/5/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
  let scaleFactor:CGFloat = 0.5
  var difficultyMultiplier = Difficultys.shared.outPutDifficultyMultiplier()
  weak var gameScene: GameScene?
//  var footBox: SKSpriteNode?
  var numOfJumpsLeft = 2
  let jumpAnimation = SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "playerJump1"), SKTexture(imageNamed: "playerJump2")], timePerFrame: (0.2 * Double(Difficultys.shared.outPutDifficultyMultiplier())), resize: true, restore: false))
  let fallAnimation =  SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "playerFall1"), SKTexture(imageNamed: "playerFall2")], timePerFrame: (0.2 * Double(Difficultys.shared.outPutDifficultyMultiplier())), resize: true, restore: false))
  let runAnimation =   SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "playerRun1"), SKTexture(imageNamed: "playerRun2"), SKTexture(imageNamed: "playerRun3"), SKTexture(imageNamed: "playerRun4"), SKTexture(imageNamed: "playerRun5"), SKTexture(imageNamed: "playerRun6")], timePerFrame: (0.1 * Double(Difficultys.shared.outPutDifficultyMultiplier())), resize: true, restore: false))
  let flipAnimation = SKAction.animate(with: [SKTexture(imageNamed: "playerFlip1"), SKTexture(imageNamed: "playerFlip2"), SKTexture(imageNamed: "playerFlip3"), SKTexture(imageNamed: "playerFlip4")], timePerFrame: (0.1 * Double(Difficultys.shared.outPutDifficultyMultiplier())), resize: true, restore: false)
  let rocketBoostTexture = SKTexture(imageNamed: "playerRocketBoost")
  var isBlastingOff = false
  
  
  func customInit(_ position: CGPoint, gameScene: GameScene){
    self.setScale(scaleFactor)
    let textSize = (texture?.size())!
    physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: textSize.width * scaleFactor , height: textSize.height * scaleFactor))
    physicsBody?.friction = 0.0
    physicsBody?.allowsRotation = false
    physicsBody?.restitution = 0.0
    physicsBody?.categoryBitMask = Contacts.player.rawValue
    physicsBody?.collisionBitMask = Contacts.safeGround.rawValue
    physicsBody?.contactTestBitMask = Contacts.nothing.rawValue
    self.name = "player"
    self.position = position
    self.gameScene = gameScene
  }

  // might want to change to jumps attributes
  func jump(){

    if numOfJumpsLeft > 0{
      if numOfJumpsLeft < 2 {
        startFlipTextureLoop()
      }
      physicsBody?.velocity.dy = 1000
      numOfJumpsLeft -= 1
    }
  }
  
  func startRunTextureLoop(){
    if self.isBlastingOff { return }
    removeAllActions()
    run(runAnimation, withKey: "run")
  }
  
  func startFallTextureLoop(){
    if self.isBlastingOff { return }
    removeAllActions()
    run(fallAnimation, withKey: "fall")
  }
  
  func startJumpTextureLoop(){
    if self.isBlastingOff { return }
    removeAllActions()
    run(jumpAnimation, withKey: "jump")
  }
  
  func startFlipTextureLoop(){
    if self.isBlastingOff { return }
    removeAllActions()
    run(flipAnimation, withKey: "flip")
  }
  
  func blastOff(){
    
    if !isBlastingOff{// check if already blasting off
      isBlastingOff = true// prevent stacked blasting off
      numOfJumpsLeft = 2
      
      let rocketFlame = SKEmitterNode(fileNamed: "rocketFlame")!
      rocketFlame.position = CGPoint(x: 0, y: -(self.size.height / 2))
      rocketFlame.zPosition = 2
      rocketFlame.name = "rocketFlame"
      
      let rocketTexture = SKAction.run { [unowned self] in
        self.texture = self.rocketBoostTexture// set rocket texture loop
        self.addChild(rocketFlame)// add rocket flame effect
      }
      
      let blastOffFinishPoint = CGPoint(x: 0, y: ((gameScene?.view?.frame.maxY)!) - (self.frame.height) )
      let path = UIBezierPath()
      path.move(to: self.position)
      path.addLine(to: blastOffFinishPoint)
      let blastOffDuration = findblastOffDuration(startingPoint: self.position, finishPoint: blastOffFinishPoint)
      
      let blastPath = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, duration: blastOffDuration)
      
      let stopBlastingOff = SKAction.run {
        self.isBlastingOff = false
        self.physicsBody?.isResting = true
        self.zRotation = 0// return orientation to normal
        self.childNode(withName: "rocketFlame")?.removeFromParent() //removes the rocket fire
      }
      
      removeAllActions()// clean of any other texture loops

      let sequence = SKAction.sequence([rocketTexture,blastPath, stopBlastingOff])
      run(sequence,withKey: "blastingOff")
    }
  }
  
  
  
  func findblastOffDuration(startingPoint: CGPoint, finishPoint: CGPoint)-> Double{
    
    let blastDist = vectorMath.findDistanceBetween(point1: startingPoint, point2: finishPoint)
    let maxBlastDist = vectorMath.findDistanceBetween(point1: CGPoint(x: 0, y: 0), point2: finishPoint)
    let diffRatio = blastDist / maxBlastDist
    
    let maxTimeToBlast = Double(1.0 * difficultyMultiplier)
    let blastingDuration = (maxTimeToBlast * diffRatio)
    
    return blastingDuration    
  }
  
}
