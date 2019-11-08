//
//  HighScoreDataBase.swift
//  JumperDude
//
//  Created by pro on 7/23/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import Foundation


class HighScoreDataBase: NSObject, NSCoding {
  static let dataBase = HighScoreDataBase()
  var highScores = [HighScore]()
  var dataUrl: URL
  
  enum Keys: String{
    case highScores = "highScores"
    case highScoreDataFile = "HighScoreData"
    case highScoreDataKeyUserDefaults = "highScoresDataUrl"
  }
  
  override init(){
    var urlString: URL
    if let userDefualtString = UserDefaults.standard.url(forKey: Keys.highScoreDataKeyUserDefaults.rawValue){
      urlString = userDefualtString
    } else {
      urlString = HighScoreDataBase.getDocumentsDirectory().appendingPathComponent(Keys.highScoreDataFile.rawValue)
      
      UserDefaults.standard.set(urlString, forKey: Keys.highScoreDataKeyUserDefaults.rawValue)
    }
    self.dataUrl = urlString
    super.init()
    getData()
  }
  
  func saveData(){
    do {
      let data = try NSKeyedArchiver.archivedData(withRootObject: highScores, requiringSecureCoding: false)
      try data.write(to: dataUrl)
    } catch {
      print("Couldn't write file \(error.localizedDescription)")
    }
  }
  
  func getData(){
    var data: Data
    
    do {
      data  = try Data(contentsOf: dataUrl )
    } catch {
      print("couldn't load data from url Path: \(error.localizedDescription)")
      highScores = HighScoreDataBase.populateInitalData()
      saveData()
      return
    }
    
    do {
      if let loadedScores = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [HighScore] {
        highScores = loadedScores
      }
    } catch {
      print("Couldn't read file.")
    }
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(highScores, forKey: Keys.highScores.rawValue)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    aDecoder.decodeObject(forKey: Keys.highScores.rawValue) as! [HighScore]
    self.init()
  }
  
  class func populateInitalData() -> [HighScore]{
    let emptyHighScore = HighScore(distanceTraveled: 0.0, coinsPickedUp: 0, rocketsUsed: 0, score: 0.0)
    let arrayOfEmptyHighScores = Array(repeating: emptyHighScore, count: 10)
    return arrayOfEmptyHighScores
  }
  
  class func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func printself(){
    for score in highScores{
      print(score.coinsPickedUp, score.distanceTraveled, score.rocketsUsed, score.score)
    }
  }
  
  func checkIfScoreIsAHighScore(distance: Double, coins: Int, rockets: Int, score: Double) -> Bool{
    for (i, highscore) in highScores.enumerated(){
      if highscore.score < score{
        
        let newHighScore = HighScore(distanceTraveled: distance, coinsPickedUp: coins, rocketsUsed: rockets, score: score)
        highScores.insert(newHighScore, at: i)
        if highScores.count > 10{
          highScores.removeLast()
        }
        saveData()
        return true
      }
    }
    return false
  }
}
