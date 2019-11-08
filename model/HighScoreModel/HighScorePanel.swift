//
//  HighScorePanel.swift
//  JumperDude
//
//  Created by pro on 7/28/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import SpriteKit

class HighScorePanel: SKSpriteNode {
  static let singleton = HighScorePanel()
  var dataBase = HighScoreDataBase.dataBase
  let backgroundColor = UIColor.blue
  let frameSize = CGSize(width: 400, height: 600)
  let backgroundTexture = SKTexture.init(noiseWithSmoothness: 10.0, size: CGSize(width: 400, height: 600), grayscale: true)
  var highScoreLabelArray = [HighScoreLabel]()
  
  init() {
    super.init(texture: backgroundTexture, color: backgroundColor, size: frameSize)
    self.texture = backgroundTexture
    self.color = backgroundColor
    self.size = frameSize
    self.anchorPoint = CGPoint(x: 0, y: 0)
    self.name = "highScorePanel"
    self.zPosition = 2
    setupHeaders()
    setUpLabels()
    loadData()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupHeaders(){
    let rocketIcon = SKSpriteNode(imageNamed: "rocket")
    rocketIcon.position = CGPoint(x: 65, y: 550)
    rocketIcon.zPosition = 1
    rocketIcon.scale(to: CGSize(width: 40, height: 80))
    addChild(rocketIcon)
    
    let coinIcon = SKSpriteNode(imageNamed: "coin1")
    coinIcon.position = CGPoint(x: 130, y: 550)
    coinIcon.zPosition = 1
    coinIcon.scale(to: CGSize(width: 50, height: 50))
    addChild(coinIcon)
    
    let distanceIcon = SKSpriteNode(imageNamed: "playerRun4")
    distanceIcon.position = CGPoint(x: 220, y: 550)
    distanceIcon.zPosition = 1
    distanceIcon.scale(to: CGSize(width: 60, height: 60))
    addChild(distanceIcon)
    
    let scoreHeaderLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreHeaderLabel.position = CGPoint(x: 325, y: 550)
    scoreHeaderLabel.zPosition = 1
    scoreHeaderLabel.horizontalAlignmentMode = .center
    scoreHeaderLabel.verticalAlignmentMode = .center
    scoreHeaderLabel.text = "SCORE"
    addChild(scoreHeaderLabel)
  }
  
  func setUpLabels(){
    var counter = 0
    for y in stride(from: 450, through: 0, by: -50){
      let highScoreLabel = HighScoreLabel()
      highScoreLabel.position = CGPoint(x: 0, y: y)
      addChild(highScoreLabel)
      highScoreLabelArray.append(highScoreLabel)
      let postionLabel = SKLabelNode(fontNamed:"Chalkduster")
      counter += 1
      postionLabel.text = "\(counter)"
      postionLabel.fontSize = 27
      postionLabel.position = CGPoint(x: 17, y: y + 12)
      addChild(postionLabel)
    }
  }
  
  func loadData(){
    let highScores = dataBase.highScores
    for (index,score) in highScores.enumerated(){
      let currentLabel = highScoreLabelArray[index]
      currentLabel.labelArray[0].text = String(score.rocketsUsed)
      currentLabel.labelArray[1].text = String(score.coinsPickedUp)
      currentLabel.labelArray[2].text = String(score.distanceTraveled)
      currentLabel.labelArray[3].text = String(score.score)
    }
  }
}

class HighScoreLabel: SKSpriteNode {
  let labelTexture = SKTexture(noiseWithSmoothness: 10.0, size: CGSize(width: 400, height: 50), grayscale: true)
  var labelArray = [SKLabelNode]()
  
  init() {
    super.init(texture: labelTexture, color: .red, size: labelTexture.size())
    self.anchorPoint = CGPoint(x: 0, y: 0)
    
    let fontSize:CGFloat = 28.0
    let rocketLabel = SKLabelNode(fontNamed: "Chalkduster")
    rocketLabel.position = (CGPoint(x: 65, y: 20))
    rocketLabel.verticalAlignmentMode = .center
    rocketLabel.horizontalAlignmentMode = .center
    rocketLabel.text = "100"
    rocketLabel.fontSize = fontSize
    addChild(rocketLabel)
    
    let coinLabel = SKLabelNode(fontNamed: "Chalkduster")
    coinLabel.position = (CGPoint(x: 130, y: 20))
    coinLabel.verticalAlignmentMode = .center
    coinLabel.horizontalAlignmentMode = .center
    coinLabel.text = "100"
    coinLabel.fontSize = fontSize
    addChild(coinLabel)
    
    let distanceLabel = SKLabelNode(fontNamed: "Chalkduster")
    distanceLabel.position = (CGPoint(x: 215, y: 20))
    distanceLabel.verticalAlignmentMode = .center
    distanceLabel.horizontalAlignmentMode = .center
    distanceLabel.text = "1000.0"
    distanceLabel.fontSize = fontSize
    addChild(distanceLabel)
    
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.position = (CGPoint(x: 335, y: 20))
    scoreLabel.verticalAlignmentMode = .center
    scoreLabel.horizontalAlignmentMode = .center
    scoreLabel.text = "10000.0"
    scoreLabel.fontSize = fontSize
    addChild(scoreLabel)
    
    labelArray = [rocketLabel,coinLabel,distanceLabel,scoreLabel]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
