//
//  backGrounds.swift
//  JumperDude
//
//  Created by pro on 8/1/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import SpriteKit

class BackgroundConveyer {
  var gameScene: GameScene!
  var difficultyMutiplier = Difficultys.shared.outPutDifficultyMultiplier()
  var viewCenter: CGPoint!
  var conveyStartPos: CGPoint?
  var halfviewWidth: CGFloat!
  var halfViewHeight: CGFloat!
  
  init(gameScene: GameScene){
    self.gameScene = gameScene
    self.viewCenter = CGPoint(x: 0, y: (gameScene.view?.frame.midY)!)
    self.halfviewWidth = CGFloat(gameScene.frame.maxX)
    self.halfViewHeight = CGFloat(gameScene.frame.midY)
    createLayers()
  }
  
  func createLayers(){
    conveyStartPos = CGPoint(x: halfviewWidth, y: halfViewHeight)

      for i in 1...5{
        let layer = SKSpriteNode(imageNamed: "doubleWidePLX-\(i)")
        layer.zPosition = CGFloat(-(i+1))
        layer.scale(to: CGSize(width: 4*halfviewWidth, height: 2*halfViewHeight))
        layer.position = conveyStartPos!
        gameScene.addChild(layer)
        getMoving(layer, layerNum: i)
      }
  }
  
  func getMoving(_ node: SKSpriteNode,layerNum: Int){
    // set a standard of speed for a standard distance
    // 100 points per second
    
    let moveSpeed = CGFloat(200 / 1) * ( 1.0 / difficultyMutiplier)

    // get node position
    let nodePosition = node.position
   
    // get exit point
    let exitPoint = -(halfviewWidth)
  
    // distance needed to travel
    let distanceToTravel = nodePosition.x + abs(exitPoint)
    
    // computed time between start and exit point, adjusted for diff and layer
    
    let timeNeededToTravel = ((Double(distanceToTravel / moveSpeed)) * Double(layerNum))
    // multiply that by the diff mutiplier
    // multiplie it by the distance required.

    // create skaction with move by :travelDistance and duration: travel time
    let move = SKAction.moveBy(x: -distanceToTravel, y: 0, duration: timeNeededToTravel)

//    print("layerNum:",layerNum, "pos:",nodePosition, "moveSpeed:",moveSpeed, "exitPoint:", exitPoint, "distanceToTravel:",distanceToTravel, "timeNeededToTravel:", timeNeededToTravel, node.size)
    
    node.run(move, completion: {
      node.position = self.conveyStartPos!
      self.getMoving(node, layerNum: layerNum)
    })
  }
}
