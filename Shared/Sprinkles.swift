let StartingColumn = 4
let StartingRow = 0

let PreviewColumn = 12
let PreviewRow = 1

let PointsPerLine = 10
let LevelThreshold = 500

protocol SprinklesDelegate
{
  func gameDidEnd(sprinkles: Sprinkles)
  func gameDidBegin(sprinkles: Sprinkles)
  func gameShapeDidLand(sprinkles: Sprinkles)
  func gameShapeDidMove(sprinkles: Sprinkles)
  func gameShapeDidDrop(sprinkles: Sprinkles)
  func gameDidLevelUp(sprinkles: Sprinkles)
}

class Sprinkles
{
  var blockArray: Grid<Block>
  var nextShape: Shape?
  var fallingShape: Shape?
  var delegate: SprinklesDelegate?
  
  var score = 0
  var level = 1
  
  init()
  {
    fallingShape = nil
    nextShape = nil
    blockArray = Grid<Block>(columns: Int(NumColumns), rows: Int(NumRows))
  }
  
  func beginGame()
  {
    if (nextShape == nil) {
      nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
    }
    
    delegate?.gameDidBegin(sprinkles: self)
  }
  
  func newShape() -> (fallingShape:Shape?, nextShape:Shape?)
  {
    fallingShape = nextShape
    nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
    fallingShape?.moveTo(StartingColumn, row: StartingRow)
    
    guard detectIllegalPlacement() == false else {
      nextShape = fallingShape
      nextShape!.moveTo(PreviewColumn, row: PreviewRow)
      endGame()
      
      return (nil, nil)
    }
    
    return (fallingShape, nextShape)
  }
  
  func detectIllegalPlacement() -> Bool
  {
    guard let shape = fallingShape else {
      return false
    }
    
    for block in shape.blocks
    {
      if block.column < 0 || block.column >= Int(NumColumns) || block.row < 0 || block.row >= Int(NumRows) {
        return true
      }
      else if blockArray[block.column, block.row] != nil {
        return true
      }
    }
    
    return false
  }
  
  func settleShape()
  {
    guard let shape = fallingShape else {
      return
    }
  
    for block in shape.blocks
    {
      blockArray[block.column, block.row] = block
    }
    
    fallingShape = nil
    delegate?.gameShapeDidLand(sprinkles: self)
  }
  
  
  func detectTouch() -> Bool
  {
    guard let shape = fallingShape else {
      return false
    }
  
    for bottomBlock in shape.bottomBlocks
    {
      if bottomBlock.row == Int(NumRows) - 1 || blockArray[bottomBlock.column, bottomBlock.row + 1] != nil
      {
        return true
      }
    }
    
    return false
  }
  
  func endGame()
  {
    score = 0
    level = 1
    delegate?.gameDidEnd(sprinkles: self)
  }
  
  func removeAllBlocks() -> Array<Array<Block>>
  {
    var allBlocks = Array<Array<Block>>()
    
    for row in 0..<Int(NumRows)
    {
      var rowOfBlocks = Array<Block>()
      
      for column in 0..<Int(NumColumns)
      {
        guard let block = blockArray[column, row] else {
          continue
        }
        rowOfBlocks.append(block)
        blockArray[column, row] = nil
      }
      
      allBlocks.append(rowOfBlocks)
    }
    
    return allBlocks
  }
  
  func removeCompletedLines() -> (linesRemoved: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>)
  {
    var removedLines = Array<Array<Block>>()
  
    for row in (1..<Int(NumRows)).reversed()
    {
      var rowOfBlocks = Array<Block>()
    
      for column in 0..<Int(NumColumns)
      {
        guard let block = blockArray[column, row] else {
          continue
        }
        
        rowOfBlocks.append(block)
      }
      
      if rowOfBlocks.count == Int(NumColumns)
      {
        removedLines.append(rowOfBlocks)
      
        for block in rowOfBlocks {
          blockArray[block.column, block.row] = nil
        }
      }
    }
    
    if removedLines.count == 0 {
      return ([], [])
    }
    
    let pointsEarned = removedLines.count * PointsPerLine * level
    score += pointsEarned
    
    if score >= level * LevelThreshold {
      level += 1
      delegate?.gameDidLevelUp(sprinkles: self)
    }
    
    var fallenBlocks = Array<Array<Block>>()
    
    for column in 0..<Int(NumColumns)
    {
      var fallenBlocksArray = Array<Block>()
      for row in (1..<removedLines[0][0].row).reversed()
      {
        guard let block = blockArray[column, row] else {
          continue
        }
      
        var newRow = row
        
        while (newRow < Int(NumRows) - 1 && blockArray[column, newRow + 1] == nil)
        {
          newRow += 1
        }
        
        block.row = newRow
        blockArray[column, row] = nil
        blockArray[column, newRow] = block
        fallenBlocksArray.append(block)
      }
      
      if fallenBlocksArray.count > 0 {
        fallenBlocks.append(fallenBlocksArray)
      }
    }
    
    return (removedLines, fallenBlocks)
  }
  
  func dropShape()
  {
    guard let shape = fallingShape else {
      return
    }
  
    while detectIllegalPlacement() == false
    {
      shape.lowerShapeByOneRow()
    }
    
    shape.raiseShapeByOneRow()
    delegate?.gameShapeDidDrop(sprinkles: self)
  }
  
  func letShapeFall()
  {
    guard let shape = fallingShape else {
      return
    }
  
    shape.lowerShapeByOneRow()
    
    if detectIllegalPlacement() {
      shape.raiseShapeByOneRow()
      
      if detectIllegalPlacement() {
        endGame()
      }
      else {
        settleShape()
      }
    }
    else {
      delegate?.gameShapeDidMove(sprinkles: self)
      
      if detectTouch() {
        settleShape()
      }
    }
  }
  
  func rotateShape()
  {
    guard let shape = fallingShape else {
      return
    }
  
    shape.rotateClockwise()
    
    guard detectIllegalPlacement() == false else {
      shape.rotateCounterClockwise()
      return
    }
    
    delegate?.gameShapeDidMove(sprinkles: self)
  }
  
  
  func moveShapeLeft()
  {
    guard let shape = fallingShape else {
      return
    }
    
    shape.shiftLeftByOneColumn()
    
    guard detectIllegalPlacement() == false else {
      shape.shiftRightByOneColumn()
      return
    }
    
    delegate?.gameShapeDidMove(sprinkles: self)
  }
  
  func moveShapeRight()
  {
    guard let shape = fallingShape else {
      return
    }
    
    shape.shiftRightByOneColumn()
    guard detectIllegalPlacement() == false else {
      shape.shiftLeftByOneColumn()
      return
    }
    
    delegate?.gameShapeDidMove(sprinkles: self)
  }
  
  func moveShapeDown()
  {
    guard let shape = fallingShape else {
      return
    }
    
    shape.shiftDownByOneColumn()
    
    guard detectIllegalPlacement() == false else {
      shape.shiftDownByOneColumn()
      return
    }
    
    delegate?.gameShapeDidMove(sprinkles: self)
  }
  
}
