//
//  GameOverScreen.swift
//  JumperDude
//
//  Created by pro on 7/17/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
  var coinsPickedUp = 0
  var rocketsUsed = 0
  var distanceTraveled = 0.0
  var score = 0.0
  var coinsPickedUpLabel: SKLabelNode!
  var rocketsUsedLabel: SKLabelNode!
  var distanceTraveledLabel: SKLabelNode!
  var scoreLabel: SKLabelNode!
  var highScorePanel: HighScorePanel!
  let defualts = UserDefaults.standard
  let sFX = SoundEffectsManager.sharedSFX
  
  override func didMove(to view: SKView) {
    score = computeScore(distanceTraveled, rocketsUsed, coinsPickedUp)
    score.toAPrecision(of: 2)
    
    distanceTraveled.toAPrecision(of: 2)
    
    scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
    scoreLabel.text = "Score: \(score)"
    
    rocketsUsedLabel = childNode(withName: "rocketsUsedLabel") as? SKLabelNode
    rocketsUsedLabel.text = "Rockets Used: \(rocketsUsed)"
    
    distanceTraveledLabel = childNode(withName: "distanceTraveledLabel") as? SKLabelNode
    distanceTraveledLabel.text = "Distance: \(distanceTraveled) meters"
    
    coinsPickedUpLabel = childNode(withName: "coinsPickedUpLabel") as? SKLabelNode
    coinsPickedUpLabel.text = "Coins Picked Up: \(coinsPickedUp)"
    
    if HighScoreDataBase.dataBase.checkIfScoreIsAHighScore(distance: distanceTraveled, coins: coinsPickedUp, rockets: rocketsUsed, score: score){
      newHighScoreCelebration()
    }
    
    highScorePanel = HighScorePanel.singleton
    highScorePanel.position = CGPoint(x: 768, y: 80)
    highScorePanel.loadData()
    addChild(highScorePanel)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {return}
    let location = touch.location(in: self)
    let objects = nodes(at: location)
    
    for node in objects{
      guard let name = node.name else { continue }
      if name == "playAgainLabel"{
        goToGame()
      } else if name == "mainMenuLabel"{
        goToMainScreen()
      }
    }
  }
  
  func goToMainScreen(){
    highScorePanel.removeFromParent()
    if let scene = MainMenuScene(fileNamed: "MainMenuScene"){
      scene.scaleMode = .aspectFill
      let transition = SKTransition.moveIn(with: .up, duration: 0.5)
      self.view?.presentScene(scene, transition: transition)
    }
  }
  
  func goToGame(){
    if let scene = GameScene(fileNamed: "GameScene"){
      scene.scaleMode = .resizeFill
      let transition = SKTransition.moveIn(with: .up, duration: 0.5)
      self.view?.presentScene(scene, transition: transition)
    }
  }
  
  func computeScore(_ distance: Double, _ rocketsUsed: Int, _ coinsPickedUp: Int) -> Double{
     let coinMultiplier = (Double(coinsPickedUp) * 0.1) + 1
    let rocketMultiplier = (Double(rocketsUsed) * 0.3) + 1
    let score = distance * coinMultiplier * rocketMultiplier
    return score
  }
  
  func startSparklers(){
    print("yay new highscore party!!")
    childNode(withName: "newHighScoreLabel")?.isHidden = false
    enumerateChildNodes(withName: "sparklePlaceHolder") { node, _ in
      let position = node.position
      node.removeFromParent()
      
      guard let redSparkles = SKEmitterNode(fileNamed: "redSparkles") else { assertionFailure("couldn't find the sparkle emmitter file")
        return }
      guard let blueSparkles = SKEmitterNode(fileNamed: "blueSparkles") else { assertionFailure("couldn't find the sparkle emmitter file")
        return }
      guard let greenSparkles = SKEmitterNode(fileNamed: "greenSparkles") else { assertionFailure("couldn't find the sparkle emmitter file")
        return }
      let arrayOfsparkles = [redSparkles,blueSparkles,greenSparkles]
      
      for sparkle in arrayOfsparkles{
        sparkle.position = position
        sparkle.zPosition = -1
        self.addChild(sparkle)
      }
    }
  }
  
  
  func newHighScoreCelebration(){
    if defualts.bool(forKey: UDefKeys.isSoundEffectsOn.rawValue){
      run(sFX.achievementSound)
    }
    startSparklers()
  }
}
