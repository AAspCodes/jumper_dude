//
//  MainScreen.swift
//  JumperDude
//
//  Created by pro on 7/17/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
  var optionsPanelReferenceNode: SKReferenceNode!
  var optionsPanel: SKNode!
  var isOptionsPanelShowing = false
  var highScorePanel: HighScorePanel!
  var isHighScorePanelShowing = false
  let defaults = UserDefaults.standard
  let music = MusicManager.sharedPlayer
  
  override func didMove(to view: SKView) {
    optionsPanelReferenceNode = childNode(withName: "optionsPanelRefferenceNode") as? SKReferenceNode
    optionsPanel = optionsPanelReferenceNode.children.first
    highScorePanel = HighScorePanel.singleton
    highScorePanel.position = CGPoint(x: 1344, y: 80)
    highScorePanel.loadData()
    addChild(highScorePanel)
  
    applyUserDataToOptionsPanel()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {return}
    let location = touch.location(in: self)
    let objects = nodes(at: location)
    
    for node in objects{
      guard let name = node.name else { continue }
      
      switch name {
      case "playLabel":
        goToGameScene()
        return
      case "optionsLabel":
        displayOptionsPanel()
      case "highScoreLabel":
        displayHighScorePanel()
      case "musicNameLabel":
        changeMusic(node)
      case "difficultyLabel":
        changeDifficulty(node)
      case "isMusicOnLabel":
        toggleIsMusicOn(node)
      case "isSoundEffectsOnLabel":
        toggleIsSoundEffectsOn(node)
      default:
        print("touched something on the main menu.")
      }
    }
  }
  
  
  func displayOptionsPanel(){
    guard let optionsPanelACFrame = optionsPanelReferenceNode.children.first?.calculateAccumulatedFrame() else {return}
    let optionsPanelWidth = optionsPanelACFrame.size.width
    let buffer:CGFloat = 30.0
    let optionsPanelSlideAction = SKAction.moveBy(x: optionsPanelWidth + buffer, y: 0.0, duration: 0.2)
    
    if isOptionsPanelShowing{
      optionsPanelReferenceNode.run(optionsPanelSlideAction.reversed())
      isOptionsPanelShowing = false
    } else {
      optionsPanelReferenceNode.run(optionsPanelSlideAction)
      isOptionsPanelShowing = true
    }
  }
  
  func displayHighScorePanel(){
    let slideHighScorePanel = SKAction.moveBy(x: -430, y: 0, duration: 0.2)
    if isHighScorePanelShowing{
      highScorePanel.run(slideHighScorePanel.reversed())
      isHighScorePanelShowing = false
    }else {
      highScorePanel.run(slideHighScorePanel)
      isHighScorePanelShowing = true
    }
  }
  
  func goToGameScene(){
    if let scene = GameScene(fileNamed: "GameScene"){
      scene.scaleMode = .resizeFill
      highScorePanel.removeFromParent()
      let transition = SKTransition.moveIn(with: .up, duration: 0.5)
      self.view?.presentScene(scene, transition: transition)
    }
  }
  
  func changeMusic(_ node: SKNode){
    // cycles the song file and restarts playing
    var trackNum = defaults.integer(forKey: UDefKeys.musicTrackNum.rawValue)
    if trackNum < 6{
      trackNum += 1
    } else {
      trackNum = 1
    }
    
    defaults.set(trackNum, forKey: UDefKeys.musicTrackNum.rawValue)
    music.playTrack(num: trackNum)
    
    let musicLabel = node as! SKLabelNode
    musicLabel.text = "Music Track: \(trackNum)"
  }
  
  func toggleIsSoundEffectsOn(_ node: SKNode){
    let isSoundEffectsOnLabelNode = node as! SKLabelNode
    let isSoundEffectsOn = defaults.bool(forKey: UDefKeys.isSoundEffectsOn.rawValue)
   
    // invert soundEffects on/off Label
    isSoundEffectsOnLabelNode.text = isSoundEffectsOn ? "Sound Effects: Off" : "SoundEffects: ON"
    
    // if on, switch defualts to false
    if isSoundEffectsOn{
      defaults.set(false, forKey: UDefKeys.isSoundEffectsOn.rawValue)

    } else {
      // if off switch defaults to true
      defaults.set(true, forKey: UDefKeys.isSoundEffectsOn.rawValue)
      
    }
  }
  
  func toggleIsMusicOn(_ node: SKNode){
    let isMusicOnLabelNode = node as! SKLabelNode
    let isMusicOn = defaults.bool(forKey: UDefKeys.isMusicOn.rawValue)

    isMusicOnLabelNode.text = isMusicOn ? "Music:Off" : "Music: ON"
    
    // if on, switch defualts to false and stop music.
    if isMusicOn{
      defaults.set(false, forKey: UDefKeys.isMusicOn.rawValue)
      music.musicPlayer.stop()
    } else {
       // if off switch defaults to true and play musi
      defaults.set(true, forKey: UDefKeys.isMusicOn.rawValue)
      music.playTrack(num: defaults.integer(forKey: UDefKeys.musicTrackNum.rawValue))
    }
  }
  
  func changeDifficulty(_ node: SKNode){
    let diffLabel = node as! SKLabelNode
    Difficultys.shared.incrementDifficulty()
    Difficultys.shared.updateUserDefualts()
    let diffName = Difficultys.shared.findDifficultiesName()
    diffLabel.text = "Difficulty: \(diffName)"
  }
  
  
  func applyUserDataToOptionsPanel(){
    let defaults = UserDefaults.standard
    for label in optionsPanel.children{
      guard let labelName = label.name else { continue }
      guard let labelNode:SKLabelNode = label as? SKLabelNode else { continue }
      switch labelName{

      case "musicNameLabel":
        let trackNum = defaults.integer(forKey: UDefKeys.musicTrackNum.rawValue)
        labelNode.text = "Music Track: \(trackNum)"
      case "difficultyLabel":
        var diffName = Difficultys.shared.findDifficultiesName()
        labelNode.text = "Difficulty: \(diffName)"
      case "isSoundEffectsOnLabel":
        let isSFXON = defaults.bool(forKey: UDefKeys.isSoundEffectsOn.rawValue)
        if isSFXON{
          labelNode.text = "Sound Effects: ON"
        } else {
          labelNode.text = "Sound Effects: OFF"
        }
      case "isMusicOnLabel":
        let isMusicOn = defaults.bool(forKey: UDefKeys.isMusicOn.rawValue)
        if isMusicOn{
          labelNode.text = "Music: ON"
        } else {
          labelNode.text = "Music: OFF"
        }
            default:
        continue
      }
    }
  }
}
