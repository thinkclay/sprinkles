import SpriteKit

// Num Columns is a constant, as it's the least forgiving constraint in portrait
let NumColumns = CGFloat(15)
// NumRows is variable based on GameLayer Height / Block Size
var NumRows = CGFloat(5)
//  We define the Block Size based on GameLayer Width / NumColumns
var BlockSize = CGFloat(20)

// Boundary for Game Play
let Padding = CGFloat(20)
var RemainderOffset = CGFloat(0)

let TickLengthLevelOne = TimeInterval(600)

class GameScene: SKScene, SprinklesDelegate
{
  var sprinkles: Sprinkles!
  let gameLayer = SKSpriteNode()
  let shapeLayer = SKNode()
  var LayerPosition = CGPoint(x: 0, y: 0)
  
  var tick:(() -> ())?
  var tickLengthMillis = TickLengthLevelOne
  var lastTick: Date?
  
  // Working with gestures
  var touchStartPoint: CGPoint?
  var touchMoved: Bool = false
  let minSwipeDistance: CGFloat = BlockSize * 0.9
  
  override func didMove(to view: SKView)
  {    
    anchorPoint = CGPoint(x: 0, y: 1.0)
    
    let background = SKSpriteNode(imageNamed: "background")
    background.color = .red
    background.anchorPoint = CGPoint(x: 0, y: 1.0)
    addChild(background)
    
    RemainderOffset = scene!.frame.height.truncatingRemainder(dividingBy: 10)
    
    gameLayer.color = Color(hue: 0, saturation: 0, brightness: 0, alpha: 0.1)
    gameLayer.size = CGSize(width: scene!.frame.width - (2 * Padding), height: scene!.frame.height - 20 - (2 * Padding) + RemainderOffset)
    gameLayer.anchorPoint = CGPoint(x: 0, y: 1)
    gameLayer.position = CGPoint(x: Padding, y: -(2 * Padding) + RemainderOffset)
    addChild(gameLayer)
    
    BlockSize = (gameLayer.size.width / CGFloat(NumColumns)).rounded(.down)
    NumRows = (gameLayer.size.height / BlockSize).rounded()
    
    if scene!.size.width <= 320.0
    {
      LayerPosition = CGPoint(x: 7, y: 1)
    }
    else if scene!.size.width == 375.0
    {
      LayerPosition = CGPoint(x: 7, y: -3)
    }
    else if scene!.size.width == 414.0
    {
      LayerPosition = CGPoint(x: 10, y: -3)
    }
    else
    {
      LayerPosition = CGPoint(x: 0, y: 0)
    }
    
    print(gameLayer.size)
    print("Size: \(BlockSize)")
    print("Rows: \(NumRows)")
    print("Cols: \(NumColumns)")
    
    shapeLayer.position = LayerPosition
    gameLayer.addChild(shapeLayer)

    
    // run(SKAction.repeatForever(SKAction.playSoundFileNamed("theme.mp3", waitForCompletion: true)))
    
    sprinkles = Sprinkles()
    sprinkles.delegate = self
    sprinkles.beginGame()
    
    tick = didTick
  }
  
  #if os(iOS) || os(tvOS)
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    if let touch = touches.first
    {
      touchStartPoint = touch.location(in: self)
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    guard let start = touchStartPoint else { return }
    
    if let touch = touches.first
    {
      let end = touch.location(in: self)
      
      // Compute the distance between the two touches
      let dx = pow(end.x - start.x, 2)
      let dy = pow(end.y - start.y, 2)
      let distance = sqrt(dx + dy)
      
      // If it's less then our min distance, then it's a swipe
      if distance > minSwipeDistance
      {
        let xMove = end.x - start.x
        
        // It moved left or right
        if abs(xMove) > minSwipeDistance
        {
          if xMove > 0
          {
            sprinkles.moveShapeRight()
          }
          else
          {
            sprinkles.moveShapeLeft()
          }
        }
        else
        {
          // sprinkles.moveShapeDown()
          sprinkles.dropShape()
        }
        
        touchStartPoint = nil
        touchMoved = true
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    if touchMoved == false
    {
      print("tap event")
      self.sprinkles.rotateShape()
      playSound("rotate.wav")
    }

    touchStartPoint = nil
    touchMoved = false
  }
  #endif
  
  #if os(OSX)
  override func keyDown(with event: NSEvent)
  {
    let keyCode = event.keyCode
    
    switch keyCode
    {
    case 123 :
      sprinkles.moveShapeLeft()
      break
    case 124 :
      sprinkles.moveShapeRight()
      break
    case 125 :
      sprinkles.dropShape()
      break
    case 126 :
      sprinkles.rotateShape()
      break
    default :
      break
    }
  }
  #endif
  
  func playSound(_ sound:String)
  {
    run(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
  }
  
  override func update(_ currentTime: TimeInterval)
  {
    /* Called before each frame is rendered */
    guard let lastTick = lastTick else {
      return
    }
    
    let timePassed = lastTick.timeIntervalSinceNow * -1000.0
    if timePassed > tickLengthMillis {
      self.lastTick = Date()
      tick?()
    }
  }
  
  func startTicking() {
    lastTick = Date()
  }
  
  func stopTicking() {
    lastTick = nil
  }
  
  func pointForColumn(_ column: Int, row: Int) -> CGPoint
  {
    let x = LayerPosition.x + (CGFloat(column) * BlockSize)
    let y = LayerPosition.y - ((CGFloat(row) * BlockSize))
    
    return CGPoint(x: x, y: y)
  }
  
  func addPreviewShapeToScene(_ shape: Shape, completion: @escaping () -> ())
  {
    for block in shape.blocks
    {
      let color = BlockColor.random().spriteColor
      let sprite = SKSpriteNode(color: color, size: CGSize(width: BlockSize, height: BlockSize))
      
      block.sprite = sprite
      sprite.position = pointForColumn(block.column, row: block.row - 2)
      sprite.alpha = 0
      
      shapeLayer.addChild(sprite)
      
      let moveAction = SKAction.move(to: pointForColumn(block.column, row: block.row), duration: 0.2)
      moveAction.timingMode = .easeOut
      let fadeInAction = SKAction.fadeAlpha(to: 0.7, duration: 0.2)
      fadeInAction.timingMode = .easeOut
      sprite.run(SKAction.group([moveAction, fadeInAction]))
    }
    
    run(SKAction.wait(forDuration: 0.2), completion: completion)
  }
  
  func movePreviewShape(_ shape:Shape, completion:@escaping () -> ())
  {
    for block in shape.blocks {
      let sprite = block.sprite!
      let moveTo = pointForColumn(block.column, row:block.row)
      let moveToAction = SKAction.move(to: moveTo, duration: 0.2)
      moveToAction.timingMode = .easeOut
      let fadeInAction = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
      fadeInAction.timingMode = .easeOut
      sprite.run(SKAction.group([moveToAction, fadeInAction]))
    }
    run(SKAction.wait(forDuration: 0.2), completion: completion)
  }
  
  func redrawShape(_ shape:Shape, completion:@escaping () -> ())
  {
    for block in shape.blocks {
      let sprite = block.sprite!
      let moveTo = pointForColumn(block.column, row:block.row)
      let moveToAction:SKAction = SKAction.move(to: moveTo, duration: 0.05)
      moveToAction.timingMode = .easeOut
      
      if block == shape.blocks.last {
        sprite.run(moveToAction, completion: completion)
      }
      else {
        sprite.run(moveToAction)
      }
    }
  }
  
  func animateCollapsingLines(_ linesToRemove: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>, completion:@escaping () -> ()) {
    var longestDuration: TimeInterval = 0
    
    for (columnIdx, column) in fallenBlocks.enumerated()
    {
      for (blockIdx, block) in column.enumerated()
      {
        let newPosition = pointForColumn(block.column, row: block.row)
        let sprite = block.sprite!
        let delay = (TimeInterval(columnIdx) * 0.05) + (TimeInterval(blockIdx) * 0.05)
        let duration = TimeInterval(((sprite.position.y - newPosition.y) / BlockSize) * 0.1)
        let moveAction = SKAction.move(to: newPosition, duration: duration)
        moveAction.timingMode = .easeOut
        sprite.run(SKAction.sequence([SKAction.wait(forDuration: delay), moveAction]))
        longestDuration = max(longestDuration, duration + delay)
      }
    }
    
    for rowToRemove in linesToRemove
    {
      for block in rowToRemove
      {
        let randomRadius = CGFloat(UInt(arc4random_uniform(400) + 100))
        let goLeft = arc4random_uniform(100) % 2 == 0
        
        var point = pointForColumn(block.column, row: block.row)
        point = CGPoint(x: point.x + (goLeft ? -randomRadius : randomRadius), y: point.y)
        
        let randomDuration = TimeInterval(arc4random_uniform(2)) + 0.5
        var startAngle = CGFloat(M_PI)
        var endAngle = startAngle * 2
        if goLeft {
          endAngle = startAngle
          startAngle = 0
        }
        
        #if os(macOS)
          let archPath = BezierPath()
          archPath.appendArc(withCenter: point, radius: randomRadius, startAngle: startAngle, endAngle: endAngle, clockwise: goLeft)
        #else
          let archPath = BezierPath(arcCenter: point, radius: randomRadius, startAngle: startAngle, endAngle: endAngle, clockwise: goLeft)
        #endif
        
        
        let archAction = SKAction.follow(archPath.cgPath, asOffset: false, orientToPath: true, duration: randomDuration)
        archAction.timingMode = .easeIn
        let sprite = block.sprite!
        sprite.zPosition = 100
        sprite.run(
          SKAction.sequence(
            [SKAction.group([archAction, SKAction.fadeOut(withDuration: TimeInterval(randomDuration))]),
             SKAction.removeFromParent()]))
      }
    }
    
    run(SKAction.wait(forDuration: longestDuration), completion:completion)
  }
  
  func nextShape()
  {
    let newShapes = sprinkles.newShape()
    
    guard let fallingShape = newShapes.fallingShape else {
      return
    }
    
    self.addPreviewShapeToScene(newShapes.nextShape!) {}
    self.movePreviewShape(fallingShape) {
      // self.view.isUserInteractionEnabled = true
      self.startTicking()
    }
  }
  
  func didTick()
  {
    sprinkles.letShapeFall()
  }
  
  // Sprinkle Protocol Methods
  func gameDidBegin(sprinkles: Sprinkles)
  {
    // levelLabel.text = "\(sprinkles.level)"
    // scoreLabel.text = "\(sprinkles.score)"
    
    // The following is false when restarting a new game
    if sprinkles.nextShape != nil && sprinkles.nextShape!.blocks[0].sprite == nil
    {
      addPreviewShapeToScene(sprinkles.nextShape!) {
        self.nextShape()
      }
    }
    else
    {
      nextShape()
    }
  }
  
  func gameDidEnd(sprinkles: Sprinkles)
  {
    // self.view.isUserInteractionEnabled = true
    stopTicking()
    playSound("game-over.wav")
    animateCollapsingLines(sprinkles.removeAllBlocks(), fallenBlocks: sprinkles.removeAllBlocks()) {
      sprinkles.beginGame()
    }
  }
  
  func gameDidLevelUp(sprinkles: Sprinkles)
  {
    // levelLabel.text = "\(sprinkles.level)"
    
    if tickLengthMillis >= 100
    {
      tickLengthMillis -= 100
    }
    else if tickLengthMillis > 50
    {
      tickLengthMillis -= 50
    }
    
    playSound("level-up.wav")
  }
  
  func gameShapeDidDrop(sprinkles: Sprinkles)
  {
    stopTicking()
    redrawShape(sprinkles.fallingShape!) {
      sprinkles.letShapeFall()
    }
    
    playSound("thud-loud.wav")
  }
  
  func gameShapeDidLand(sprinkles: Sprinkles)
  {
    stopTicking()
    // self.view.isUserInteractionEnabled = false
    
    let removedLines = sprinkles.removeCompletedLines()
    
    if removedLines.linesRemoved.count > 0
    {
      // self.scoreLabel.text = "\(sprinkles.score)"
      animateCollapsingLines(removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
        self.gameShapeDidLand(sprinkles: sprinkles)
      }
      
      playSound("sparkle.wav")
    }
    else
    {
      nextShape()
    }
  }
  
  func gameShapeDidMove(sprinkles: Sprinkles)
  {
    redrawShape(sprinkles.fallingShape!) {}
  }
  
}
