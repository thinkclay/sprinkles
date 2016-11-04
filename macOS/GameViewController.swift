import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController
{
  
  var scene: GameScene!
  var sprinkles: Sprinkles!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    // Configure the view.
    let skView = view as! SKView
    
    // Create and configure the scene.
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .aspectFill
    
    skView.presentScene(scene)
  }
  
}
