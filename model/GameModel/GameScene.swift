//
//  GameScene.swift
//  JumperDude
//
//  Created by pro on 7/5/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  let sFX = SoundEffectsManager.sharedSFX
  let defaults = UserDefaults.standard
  var player: Player!
  var terrainCreationTimer: Timer?
  var gameCycleTimer: CADisplayLink?
  var arrayOfStartingPlatforms = [SKSpriteNode]()
  var rocket: Rocket?
  var difficultyMutiplier = Difficultys.shared.outPutDifficultyMultiplier()
  var counter = 0
  var coins = 0 {
    didSet{
      coinsPickedUpLabel.text = "Coins: \(coins)"
    }
  }
  var coinsPickedUpLabel: SKLabelNode!
  
  var travelDistance = 0.0{
    didSet{
      var adjustedDistance = travelDistance
      adjustedDistance.toAPrecision(of: 2)
      travelDisLabel.text = "Distance: \(adjustedDistance)"
    }
  }
  var travelDisLabel: SKLabelNode!
  var numOfRocketUsed = 0
  var wasLastTerrainAir = true
  var counterThreashHold: Int!
  var halfViewWidth: Int!
  var viewHeight: Int!
  
  
  var conveyer: BackgroundConveyer! 
  
  override func didMove(to view: SKView) {
    physicsWorld.contactDelegate = self
    physicsWorld.speed = CGFloat(1.0 / difficultyMutiplier)
    counterThreashHold = Int(28 * difficultyMutiplier)
    halfViewWidth = Int(view.frame.midX)
    viewHeight = Int(view.frame.maxY)
    
    conveyer = BackgroundConveyer(gameScene: self)
    
    
    coinsPickedUpLabel = SKLabelNode(fontNamed: "Chalkduster")
    coinsPickedUpLabel.text = "Coins: 0"
    coinsPickedUpLabel.color = .red
    coinsPickedUpLabel.horizontalAlignmentMode = .left
    coinsPickedUpLabel.verticalAlignmentMode = .center
    coinsPickedUpLabel.fontSize = 20
    coinsPickedUpLabel.position = CGPoint(x: -((halfViewWidth) - 20), y: viewHeight - 20)
    addChild(coinsPickedUpLabel)
    
    travelDisLabel = SKLabelNode(fontNamed: "Chalkduster")
    travelDisLabel.text = "Distance: 0"
    travelDisLabel.color = .red
    travelDisLabel.horizontalAlignmentMode = .left
    travelDisLabel.verticalAlignmentMode = .center
    travelDisLabel.fontSize = 20
    travelDisLabel.position = CGPoint(x: ((halfViewWidth) - 250), y: viewHeight - 20)
    addChild(travelDisLabel)
    
//    let backGround = SKSpriteNode(imageNamed: "backgroundColorGrass")
//    backGround.position = CGPoint(x: view.frame.maxX, y: view.frame.maxY)
//    backGround.zPosition = -3
//    addChild(backGround)
    
//    print(view.frame)
//    para = Backgrounds(imageName: "land", speed: 4, gameScene: self, zLayer: -3)
//    addChild(para)
//    para.moveParalax()
//    print(para.position)
    
    //finds starting platforms

    //create starting platforms based on size of the screen
    
    
    // number of platforms to be created will be the width of the view divided by the width of the terrain image
    let numOfPlatforms = (2 * halfViewWidth) / 100
    for i in 0...numOfPlatforms{
      let xPosition = CGFloat((i * 100) - halfViewWidth)
      let yPosition = CGFloat(50)
      let position = CGPoint(x: xPosition, y: yPosition)
      let startingPlatform = Terrain(at: position)
      addChild(startingPlatform)
      arrayOfStartingPlatforms.append(startingPlatform)
    }
    
//    coinsPickedUpLabel = childNode(withName: "coinsPickedUpLabel") as? SKLabelNode
//    travelDistanceLabel = childNode(withName: "travelDistanceLabel") as? SKLabelNode
    guard let placeHolder = childNode(withName: "playerPlaceholder") else {assertionFailure("couldn't find player placeHolder")
      return
    }
    player = Player(imageNamed: "playerRun1")
    player.customInit(placeHolder.position, gameScene: self)
    addChild(player)
    startTheGame()
  }
  
  func startTheGame(){
    for platform in arrayOfStartingPlatforms{
      getMoving(platform)
    }
    gameCycleTimer = CADisplayLink(target: self, selector: #selector(gameDisplayLinkTimer))
    gameCycleTimer?.add(to: RunLoop.main, forMode: .common)
  }
  
  @objc func gameDisplayLinkTimer(){
    addDistance()
    if rocket != nil {
      rocket?.hover()
    }
    
    counter += 1
    if counter >= counterThreashHold{
      createTerrainOrAir()
      counter = 0
    }
  }
  
  @objc func createTerrainOrAir(){
    if wasLastTerrainAir{
      createTerrain()
    }else{
      if Bool.random(){
        wasLastTerrainAir = true
        return
      }else{
        createTerrain()
      }
    }
  }
  
  func createTerrain(){
    wasLastTerrainAir = false
    let terrain = Terrain(scene: self)
    addChild(terrain)
    getMoving(terrain)
    let itemOffset = CGPoint(x: terrain.position.x, y: terrain.position.y + (terrain.size.height/2) + 35)
    shouldCreateItem(at: itemOffset)
  }
  
  func shouldCreateItem(at position: CGPoint){
    if Int.random(in: 0...2) == 0{// control chance of coin spawn
      let coin = Coin(at: position)
      addChild(coin)
      getMoving(coin)
    }else if !player.isBlastingOff && player.position.x < -10 { // control chance of rockets spawn
      if childNode(withName: "rocket") != nil {
        return
      }
      rocket = Rocket(at: position)
      addChild(rocket!)
      getMoving(rocket!)
    }
  }
  
//  func getMoving(_ node: SKSpriteNode){
//    // get node position
//    let nodePosition = node.position
//    // get exit point
//    let exitPoint = -(node.size.width / 2)
//    // get standard travel distance
//    guard let standardTravelDistance = view?.frame.maxX else { assertionFailure("couldn't find the view.frame.maxX for the get moving function")
//      return
//    }
//    // get standard travel time
//    let standardTravelTime = CGFloat(3.0 * difficultyMutiplier)
//    // the difference between the node position and the exit point is the travel distance
//    let travelDistance = abs(exitPoint - nodePosition.x)
//    // the travelDist/ standard travel Distance == travel time/ standard travel time. solve for travel time.
//    let travelTime = abs(Double((travelDistance * standardTravelTime) / standardTravelDistance))
//    // create skaction with move by :travelDistance and duration: travel time
//    let move = SKAction.moveBy(x: -travelDistance, y: 0, duration: travelTime)
//    let seq = SKAction.sequence([move, SKAction.removeFromParent()])
//    node.run(seq)
//  }
  func getMoving(_ node: SKSpriteNode){
    // set a standard of speed for a standard distance
    // 100 points per second
    let moveSpeed = CGFloat(200 / 1) * ( 1.0 / difficultyMutiplier)	
    
    // get node position
    let nodePosition = node.position
    // get exit point
    let exitPoint = -((node.size.width / 2) + CGFloat(halfViewWidth))
    // distance needed to travel
    let distanceToTravel = nodePosition.x + abs(exitPoint)
    
    let timeNeededToTravel = Double(distanceToTravel / moveSpeed)
    
    
    // multiply that by the diff mutiplier
    // multiplie it by the distance required.

    // create skaction with move by :travelDistance and duration: travel time
    let move = SKAction.moveBy(x: -distanceToTravel, y: 0, duration: timeNeededToTravel)
    let seq = SKAction.sequence([move, SKAction.removeFromParent()])
    node.run(seq)
  }

  
  func addDistance(){
    travelDistance += 0.1
  }
  
  override func update(_ currentTime: TimeInterval) {
    if player.isBlastingOff{
      return
    }

    let playerWidth = Int(player.frame.width)
    let dangerPoint = CGFloat((halfViewWidth) + (playerWidth / 2))
    if player.position.x < -dangerPoint {
      gameOver()
      return
    }
  
    if player.position.y < -(player.size.height/2){
      gameOver()
      return
    }
    
    // Bool for if Player is on the groundd
    let isPlayerOnTheGround = checkIfOnTheGround()
    
    if isPlayerOnTheGround{
      // player is on the ground, is player Running?, if no: start running and check jumps left
      // if yes player is running, all is well: return
      if player.action(forKey: "run") == nil{
        player.startRunTextureLoop()
        if player.numOfJumpsLeft != 2{
          player.numOfJumpsLeft = 2
        }
      } else {
        return
      }
    }
    
    guard let playerYvel = player.physicsBody?.velocity.dy else { assertionFailure("can't find player y velocity")
      return
    }
    
    if !player.isBlastingOff && !isPlayerOnTheGround{
      if playerYvel > 0{
        if player.action(forKey: "jump") == nil && player.action(forKey: "flip") == nil{
          player.startJumpTextureLoop()
          return
        }
      } else {
        if player.action(forKey: "fall") == nil && player.action(forKey: "flip") == nil{
          player.startFallTextureLoop()
          return
        }
      }
    }
  }
  
  func checkIfOnTheGround() -> Bool{
    let playerPosition = player.position
    let halfPHeigth = player.frame.height / 2
    let halfPWidth = player.frame.width / 2
    
    // y distance below the player to check
    let outset:CGFloat = 10.0
    
    let leftCheckPointPosition = CGPoint(x: playerPosition.x - halfPWidth, y: playerPosition.y - halfPHeigth - outset)
    let rightCheckPointPosition = CGPoint(x: playerPosition.x + halfPWidth, y: playerPosition.y - halfPHeigth - outset)
    let leftObjects = nodes(at: leftCheckPointPosition)
    let rightObjects = nodes(at: rightCheckPointPosition)
    
    if (rightObjects.contains{$0.name == "terrain"}) || (leftObjects.contains{$0.name == "terrain"}) {
      return true
    } else {
      return false
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if player.isBlastingOff{ return }
    
    player.jump()
    
    if defaults.bool(forKey: UDefKeys.isSoundEffectsOn.rawValue){
      run(sFX.jumpSound)
    }
  }
  
  func gameOver(){
    // fail Sound
    if defaults.bool(forKey: UDefKeys.isSoundEffectsOn.rawValue){
      run(sFX.failSound)
    }
    
    // stop game timers
    terrainCreationTimer?.invalidate()
    gameCycleTimer?.invalidate()
    
    goToGameOverScene()

  }
  
  func goToGameOverScene(){
    if let scene = GameOverScene(fileNamed: "GameOverScene"){
      scene.coinsPickedUp = coins
      scene.rocketsUsed = numOfRocketUsed
      scene.distanceTraveled = travelDistance
      scene.scaleMode = .aspectFill
      let transition = SKTransition.moveIn(with: .up, duration: 0.5)
      self.view?.presentScene(scene, transition: transition)
    } else {
      assertionFailure("couldn't load GameOverScene")
    }
  }
}

extension GameScene: SKPhysicsContactDelegate{
  func didBegin(_ contact: SKPhysicsContact) {
    guard let bodyA = contact.bodyA.node else {return}
    guard let bodyB = contact.bodyB.node else {return}

    var object: SKNode
    if bodyA.physicsBody?.categoryBitMask == Contacts.player.rawValue {
      object = bodyB
    }else if bodyB.physicsBody?.categoryBitMask == Contacts.player.rawValue{
      object = bodyA
    } else{
      assertionFailure("odd Collision between \(bodyA) and \(bodyB)")
      return
    }
    guard let objectName: String = object.name else {
      assertionFailure("odd Collision between \(bodyA) and \(bodyB) object had no name")
      return
    }
    
    switch objectName{
    case "coin":
      object.removeFromParent()
      coins += 1
      if defaults.bool(forKey: UDefKeys.isSoundEffectsOn.rawValue){
        run(sFX.coinSound)
      }
    case "rocket":
      player.blastOff()
      if defaults.bool(forKey: UDefKeys.isSoundEffectsOn.rawValue){
        run(sFX.rocketSound)
      }
      object.removeFromParent()
      rocket = nil
      numOfRocketUsed += 1
    default:
      print(objectName)
    }
  }
}
