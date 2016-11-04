import UIKit
import SpriteKit

class GameViewController: UIViewController
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
    
    // Create and configure the scene.
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .aspectFill
    
    skView.presentScene(scene)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
    tap.delegate = self
    skView.addGestureRecognizer(tap)
    
    let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    pan.delegate = self
    skView.addGestureRecognizer(pan)
  }
  
}
