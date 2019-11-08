//
//  SoundEffectsManager.swift
//  JumperDude
//
//  Created by pro on 7/30/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//


import SpriteKit

class SoundEffectsManager {
  static let sharedSFX = SoundEffectsManager()
  let defaults = UserDefaults.standard
  let coinSound = SKAction.playSoundFileNamed("coin.caf", waitForCompletion: false)
  let jumpSound = SKAction.playSoundFileNamed("jump.m4a", waitForCompletion: false)
  let failSound = SKAction.playSoundFileNamed("fail.caf", waitForCompletion: false)
  let achievementSound = SKAction.playSoundFileNamed("achievement.caf", waitForCompletion: false)
  let rocketSound = SKAction.playSoundFileNamed("rocket.mp3", waitForCompletion: false)
}
