//
//  HighScore.swift
//  JumperDude
//
//  Created by pro on 7/23/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import Foundation

class HighScore: NSObject, NSCoding{
  enum Keys: String{
    case distanceTraveled = "distanceTraveled"
    case coinsPickedUp = "coinsPickedUp"
    case rocketsUsed = "rocketsUsed"
    case score = "score"
  }

  var distanceTraveled: Double
  var coinsPickedUp: Int
  var rocketsUsed: Int
  var score: Double
  
  init(distanceTraveled: Double, coinsPickedUp: Int, rocketsUsed: Int, score: Double) {
    
    self.distanceTraveled = distanceTraveled
    self.coinsPickedUp = coinsPickedUp
    self.rocketsUsed = rocketsUsed
    self.score = score
    super.init()
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(distanceTraveled, forKey: Keys.distanceTraveled.rawValue)
    aCoder.encode(coinsPickedUp,forKey: Keys.coinsPickedUp.rawValue)
    aCoder.encode(rocketsUsed, forKey: Keys.rocketsUsed.rawValue)
    aCoder.encode(score,forKey: Keys.score.rawValue)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    let distanceTraveled = aDecoder.decodeDouble(forKey: Keys.distanceTraveled.rawValue)
    let coinsPickedUp = aDecoder.decodeInteger(forKey: Keys.coinsPickedUp.rawValue)
    let rocketsUsed = aDecoder.decodeInteger(forKey: Keys.rocketsUsed.rawValue)
    let score = aDecoder.decodeDouble(forKey: Keys.score.rawValue)
    self.init(distanceTraveled: distanceTraveled, coinsPickedUp: coinsPickedUp, rocketsUsed: rocketsUsed, score: score)
  }
}

