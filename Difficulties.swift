//
//  Difficulties.swift
//  JumperDude
//
//  Created by pro on 8/14/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import SpriteKit

enum Difficulties: Double{
  case superEasy = 2.0
  case easy = 1.5
  case normal = 1.0
  case hard = 0.75
  case expert = 0.5
}

class Difficultys{
  static let shared = Difficultys()
  let diffArray = [2.0, 1.5, 1.0, 0.75, 0.5]
  var difficultyPosition = 0
  
  
  func loadDifficulty(){
    difficultyPosition = UserDefaults.standard.integer(forKey: UDefKeys.difficulty.rawValue)
  }
  
  func outPutDifficultyMultiplier() -> CGFloat{
    let diffMultiplier = CGFloat(diffArray[difficultyPosition])
    return diffMultiplier
  }
  
  func findDifficultiesName()-> String{
    switch diffArray[difficultyPosition] {
    case 2.0:
      return "Ultra Casual"
    case 1.5:
      return "Casual"
    case 1.0:
      return "Normal"
    case 0.75:
      return "I had Coffee"
    case 0.5:
      return "Manic!"
    default:
      assertionFailure("this value should not be in the diff array, value : \(diffArray[difficultyPosition])")
      return " oops!"
    }
  }
  
  func incrementDifficulty(){
    let diffArrayLength = diffArray.count
    if difficultyPosition < diffArrayLength - 1{
      difficultyPosition += 1
    } else {
      difficultyPosition = 0
    }
  }
  
  func updateUserDefualts(){
    UserDefaults.standard.set(difficultyPosition, forKey: UDefKeys.difficulty.rawValue)
  }
}
