//
//  Terrain.swift
//  JumperDude
//
//  Created by pro on 7/5/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import SpriteKit

class Terrain: SKSpriteNode {
  weak var gameScene: GameScene?
  var terrainSize: CGSize!
  
  
  init(at position: CGPoint){
    let terrainTexture = SKTexture(imageNamed: "terrain")
    terrainSize = terrainTexture.size()
    super.init(texture: terrainTexture, color: .red, size: terrainSize)
    
    physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 65), center: CGPoint(x: 0, y: -2.5))
    physicsBody?.isDynamic = false
    physicsBody?.restitution = 0.0
    physicsBody?.categoryBitMask = Contacts.safeGround.rawValue
    physicsBody?.collisionBitMask = Contacts.player.rawValue
    physicsBody?.contactTestBitMask = Contacts.nothing.rawValue
    
    self.zPosition = -1
    self.name = "terrain"
    self.position = position
  }
  
  
  init(scene: GameScene){
    let terrainTexture = SKTexture(imageNamed: "terrain")

    terrainSize = terrainTexture.size()
    
    super.init(texture: terrainTexture, color: .red, size: terrainSize)
    //100, 70
    physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 65), center: CGPoint(x: 0, y: -2.5))
    physicsBody?.isDynamic = false
    physicsBody?.restitution = 0.0
    physicsBody?.categoryBitMask = Contacts.safeGround.rawValue
    physicsBody?.collisionBitMask = Contacts.player.rawValue
    physicsBody?.contactTestBitMask = Contacts.nothing.rawValue
    self.zPosition = -1
    self.name = "terrain"
    self.gameScene = scene
    guard let sceneHeight = gameScene?.view?.frame.maxY else { assertionFailure("Couldn't find the scene")
      return
    }
    let heightIncrement = (sceneHeight / 8).rounded()
    let randomHeightMultiplier = Int.random(in: 1...4)
    let yPos = (heightIncrement * CGFloat(randomHeightMultiplier)) - (terrainSize.height / 2)
    
    guard let sceneWidth = gameScene?.view?.frame.maxX else { assertionFailure("Couldn't find the scene for the scene width")
      return
    }
    
    let xPos = CGFloat((sceneWidth / 2) + (terrainSize.width / 2))
    self.position = CGPoint(x: xPos, y: yPos)
    }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
