//
//  MusicPlayer.swift
//  JumperDude
//
//  Created by pro on 7/29/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import AVFoundation

class MusicManager{
  static let sharedPlayer = MusicManager()
  var musicPlayer: AVAudioPlayer!
  var difficultyMultiplier = 2.0
  
  
  init() {
    let trackNum = UserDefaults.standard.integer(forKey: UDefKeys.musicTrackNum.rawValue)
    playTrack(num: trackNum)
   
  }
  
  func playTrack(num trackNum: Int){
    if !UserDefaults.standard.bool(forKey: UDefKeys.isMusicOn.rawValue){
      return
    }
    let path = Bundle.main.path(forResource: "track\(trackNum).caf",ofType: nil)!
    let url = URL(fileURLWithPath: path)
    
    do{
      musicPlayer = try  AVAudioPlayer(contentsOf: url)
      musicPlayer.numberOfLoops = -1
      musicPlayer.play()
    } catch {
      print("could load audio file")
    }
    
  }
  
  
  
  

}
