/*
  
 0 degrees       90 degrees      180 degrees     270 degrees
  
 [0][ ][ ][ ]    [3][2][1][0]    [3][ ][ ][ ]    [0][1][2][3]
 [1][ ][ ][ ]    [ ][ ][ ][ ]    [2][ ][ ][ ]    [ ][ ][ ][ ]
 [2][ ][ ][ ]    [ ][ ][ ][ ]    [1][ ][ ][ ]    [ ][ ][ ][ ]
 [3][ ][ ][ ]    [ ][ ][ ][ ]    [0][ ][ ][ ]    [ ][ ][ ][ ]
  
*/
class LineShape: Shape
{
  
  override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>]
  {
    return [
      Orientation.zero:       [(0, 0), (0, 1), (0, 2), (0, 3)],
      Orientation.ninety:     [(3, 0), (2, 0), (1, 0), (0, 0)],
      Orientation.oneEighty:  [(0, 3), (0, 2), (0, 1), (0, 0)],
      Orientation.twoSeventy: [(0, 0), (1, 0), (2, 0), (3, 0)]
    ]
  }
  
  override var bottomBlocksForOrientations: [Orientation: Array<Block>]
  {
    return [
      Orientation.zero:       [blocks[FourthBlockIdx]],
      Orientation.ninety:     blocks,
      Orientation.oneEighty:  [blocks[FourthBlockIdx]],
      Orientation.twoSeventy: blocks
    ]
  }
  
}
