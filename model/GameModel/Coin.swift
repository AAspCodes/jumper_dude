//
//  Coin.swift
//  JumperDude
//
//  Created by pro on 7/15/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode {
  let spinAnimation = SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "coin1"), SKTexture(imageNamed: "coin2"), SKTexture(imageNamed: "coin3"), SKTexture(imageNamed: "coin4"), SKTexture(imageNamed: "coin5"), SKTexture(imageNamed: "coin6")], timePerFrame: (0.1 * Double(Difficultys.shared.outPutDifficultyMultiplier())), resize: true, restore: false))
  
  init(at position:CGPoint) {
    let coinText = SKTexture(imageNamed: "coin1")
    let coinsize = coinText.size()
    super.init(texture: coinText, color: .red, size: coinsize)
    self.position = position
    self.scale(to: CGSize(width: 30, height: 30))
    self.physicsBody = SKPhysicsBody(circleOfRadius: 15)
    physicsBody?.isDynamic = false
    physicsBody?.categoryBitMask = Contacts.coin.rawValue
    physicsBody?.collisionBitMask = Contacts.nothing.rawValue
    physicsBody?.contactTestBitMask = Contacts.player.rawValue
    self.name = "coin"
    
    beginSpin()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func beginSpin(){
    self.run(spinAnimation)
  }
  
  
  
  
}
