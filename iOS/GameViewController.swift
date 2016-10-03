import UIKit
import SpriteKit

class GameViewController: UIViewController, SprinklesDelegate, UIGestureRecognizerDelegate
{
  
  var scene: GameScene!
  var sprinkles: Sprinkles!
  var panPointReference: CGPoint?
  
  @IBOutlet var scoreLabel: UILabel!
  @IBOutlet var levelLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure the view.
    let skView = view as! SKView
    skView.isMultipleTouchEnabled = false
    
    // Create and configure the scene.
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .aspectFill
    scene.tick = didTick
    
    sprinkles = Sprinkles()
    sprinkles.delegate = self
    sprinkles.beginGame()
    
    // Present the scene.
    skView.presentScene(scene)
  }
  
  override var prefersStatusBarHidden : Bool {
    return true
  }
  
  @IBAction func didTap(_ sender: UITapGestureRecognizer)
  {
    sprinkles.rotateShape()
    // TODO move this inside of the shape subclasses
    scene.playSound("rotate.wav")
  }
  
  @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
    let currentPoint = sender.translation(in: self.view)
    if let originalPoint = panPointReference {
      if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
        if sender.velocity(in: self.view).x > CGFloat(0) {
          sprinkles.moveShapeRight()
          panPointReference = currentPoint
        } else {
          sprinkles.moveShapeLeft()
          panPointReference = currentPoint
        }
      }
    } else if sender.state == .began {
      panPointReference = currentPoint
    }
  }
  
  @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
    sprinkles.dropShape()
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
  {
    return true
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
  {
    if gestureRecognizer is UISwipeGestureRecognizer {
      if otherGestureRecognizer is UIPanGestureRecognizer {
        return true
      }
    }
    else if gestureRecognizer is UIPanGestureRecognizer {
      if otherGestureRecognizer is UITapGestureRecognizer {
        return true
      }
    }
    return false
  }
  
  func didTick()
  {
    sprinkles.letShapeFall()
  }
  
  func nextShape()
  {
    let newShapes = sprinkles.newShape()
  
    guard let fallingShape = newShapes.fallingShape else {
      return
    }
    
    self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
    self.scene.movePreviewShape(fallingShape) {
      self.view.isUserInteractionEnabled = true
      self.scene.startTicking()
    }
  }
  
  func gameDidBegin(_ sprinkles: Sprinkles)
  {
    levelLabel.text = "\(sprinkles.level)"
    scoreLabel.text = "\(sprinkles.score)"
    scene.tickLengthMillis = TickLengthLevelOne
    
    // The following is false when restarting a new game
    if sprinkles.nextShape != nil && sprinkles.nextShape!.blocks[0].sprite == nil {
      scene.addPreviewShapeToScene(sprinkles.nextShape!) {
        self.nextShape()
      }
    } else {
      nextShape()
    }
  }
  
  func gameDidEnd(_ sprinkles: Sprinkles)
  {
    view.isUserInteractionEnabled = false
    scene.stopTicking()
    scene.playSound("game-over.wav")
    scene.animateCollapsingLines(sprinkles.removeAllBlocks(), fallenBlocks: sprinkles.removeAllBlocks()) {
      sprinkles.beginGame()
    }
  }
  
  func gameDidLevelUp(_ sprinkles: Sprinkles)
  {
    levelLabel.text = "\(sprinkles.level)"
    if scene.tickLengthMillis >= 100 {
      scene.tickLengthMillis -= 100
    } else if scene.tickLengthMillis > 50 {
      scene.tickLengthMillis -= 50
    }
    scene.playSound("level-up.wav")
  }
  
  func gameShapeDidDrop(_ sprinkles: Sprinkles)
  {
    scene.stopTicking()
    scene.redrawShape(sprinkles.fallingShape!) {
      sprinkles.letShapeFall()
    }
    scene.playSound("thud-loud.wav")
  }
  
  func gameShapeDidLand(_ sprinkles: Sprinkles)
  {
    scene.stopTicking()
    self.view.isUserInteractionEnabled = false
    let removedLines = sprinkles.removeCompletedLines()
    
    if removedLines.linesRemoved.count > 0 {
      self.scoreLabel.text = "\(sprinkles.score)"
      scene.animateCollapsingLines(removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
        self.gameShapeDidLand(sprinkles)
      }
      scene.playSound("sparkle.wav")
    } else {
      nextShape()
    }
  }
  
  func gameShapeDidMove(_ sprinkles: Sprinkles) {
    scene.redrawShape(sprinkles.fallingShape!) {}
  }
}
