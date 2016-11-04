import UIKit
import SpriteKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate
{
  
  var scene: GameScene!
  var panPointReference: CGPoint?
  
  @IBOutlet var scoreLabel: UILabel!
  @IBOutlet var levelLabel: UILabel!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    // Configure the view.
    let skView = view as! SKView
    skView.isMultipleTouchEnabled = false
    
    // Create and configure the scene.
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .aspectFill
    
    skView.presentScene(scene)
  }
  
  override var prefersStatusBarHidden : Bool
  {
    return true
  }
  
}
