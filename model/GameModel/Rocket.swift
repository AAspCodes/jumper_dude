//
//  SlingShot.swift
//  JumperDude
//
//  Created by pro on 7/9/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import SpriteKit

class Rocket: SKSpriteNode {
  var moveCounter = 0
  let rocketSizeA = CGSize(width: 30, height: 60)
  init(at position: CGPoint) {
    let rocketText = SKTexture(imageNamed: "rocket")
    let rocketSize = rocketText.size()
    super.init(texture: rocketText, color: .red, size: rocketSize)
    self.position = position
    
    self.scale(to: rocketSizeA)
    self.physicsBody = SKPhysicsBody(rectangleOf: rocketSizeA)
    physicsBody?.isDynamic = false
    physicsBody?.categoryBitMask = Contacts.rocket.rawValue
    physicsBody?.collisionBitMask = Contacts.nothing.rawValue
    physicsBody?.contactTestBitMask = Contacts.player.rawValue
    self.name = "rocket"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func hover(){
    // add 1 to move counter
    moveCounter += 1
    switch moveCounter {
    case 0..<30:// if counter is less than 30 go up,
      // move up
      position.y += 0.5
    case 30..<60: // if less than 60 go down
      // move down
      position.y -= 0.5
    default: // if more than 59 restart the cycle
      // move counter = 0 and cycle will restart
      moveCounter = 0
    }
  }
}
