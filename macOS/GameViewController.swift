import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController, SprinklesDelegate
{
  
  var scene: GameScene!
  var sprinkles: Sprinkles!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    let skView = view as! SKView
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .aspectFill
    
    //        let scene = GameScene.newGameScene()
    //
    //        // Present the scene
    //        let skView = self.view as! SKView
    //        skView.presentScene(scene)
    //
    //        skView.ignoresSiblingOrder = true
    //
    //        skView.showsFPS = true
    //        skView.showsNodeCount = true
  }
  
}

