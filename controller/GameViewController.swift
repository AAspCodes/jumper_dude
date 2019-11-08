//
//  GameViewController.swift
//  JumperDude
//
//  Created by pro on 7/5/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
 let defaults = UserDefaults.standard
  var highScoreDataBase: HighScoreDataBase!
  var music:MusicManager!
  var difficulty: Difficultys!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      if !(defaults.bool(forKey: UDefKeys.havePlayedBefore.rawValue)){
        populateUserDefaults()
      }
      music = MusicManager.sharedPlayer
      highScoreDataBase = HighScoreDataBase.dataBase
      difficulty = Difficultys.shared
      difficulty.loadDifficulty()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = MainMenuScene(fileNamed: "MainMenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
  
  func populateUserDefaults(){
    // music on
    defaults.set(true, forKey: UDefKeys.isMusicOn.rawValue)
    //sound effects on
    defaults.set(true, forKey: UDefKeys.isSoundEffectsOn.rawValue)
    // music track
    defaults.set(1, forKey: UDefKeys.musicTrackNum.rawValue)
    // game difficulty
    defaults.set(2, forKey: UDefKeys.difficulty.rawValue)
    // sets flag that means player opened the game before
    defaults.set(true, forKey: UDefKeys.havePlayedBefore.rawValue)
  }
}
