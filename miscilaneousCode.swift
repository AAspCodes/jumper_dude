//
//  enums.swift
//  JumperDude
//
//  Created by pro on 7/8/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import SpriteKit


enum Contacts: UInt32{
  case nothing = 0
  case player = 1
  case safeGround = 2
  case playerFootBox = 4
  case coin = 8
  case rocket = 16
}




class vectorMath{
  static func findDistanceBetween(point1: CGPoint, point2: CGPoint )-> Double{
    let xdiff = abs(point1.x - point2.x)
    let ydiff = abs(point1.y - point2.y)
    let hypo = Double(sqrt((xdiff * xdiff) + (ydiff * ydiff)))
    return hypo
  }
}

extension Double{
  mutating func toAPrecision(of num: Int){
    let precision:Double = pow(10, Double(num))
    self = (self * precision).rounded() / precision
  }
}

enum UDefKeys: String {
  case difficulty = "difficultyNum"
  case musicTrackNum = "musicTrackNum"
  case isMusicOn = "isMusicOn"
  case isSoundEffectsOn = "isSoundEffectsON"
  case havePlayedBefore = "havePlayedBefore"
}

class Statics{
  static let shared = Statics()
  var difficultyMultiplier: CGFloat
  
  init() {
    self.difficultyMultiplier = CGFloat(UserDefaults.standard.double(forKey: UDefKeys.difficulty.rawValue))
  }
  
  
  
  
}
