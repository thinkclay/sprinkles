import SpriteKit

enum BlockColor: Int
{
  case blue = 0, pink, red, green
  
  var spriteColor: Color {
    switch self
    {
      case .blue :
        return Color.init(red: 68/255, green: 85/255, blue: 166/255, alpha: 1)
      case .pink :
        return Color.init(red: 196/255, green: 118/255, blue: 175/255, alpha: 1)
      case .red :
        return Color.init(red: 167/255, green: 62/255, blue: 79/255, alpha: 1)
      case .green :
        return Color.init(red: 139/255, green: 197/255, blue: 98/255, alpha: 1)
    }
  }
  
  static func random() -> BlockColor
  {
    return BlockColor(rawValue: Int(arc4random_uniform(4)))!
  }
}

class Block: Hashable, CustomStringConvertible
{
  // Constants
  let color: BlockColor
  
  // Variables
  var column: Int
  var row: Int
  
  // Lazy loading
  var sprite: SKSpriteNode?
  
  var hashValue: Int {
    return self.column ^ self.row
  }
  
  var description: String {
    return "(\(column), \(row))"
  }
  
  init(column: Int, row: Int, color: BlockColor)
  {
    self.column = column
    self.row = row
    self.color = color
  }
}

func ==(lhs: Block, rhs: Block) -> Bool
{
  return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}
