/*
 
 0 degrees       90 degrees      180 degrees     270 degrees
 
 [0][1][ ][ ]    [3][0][ ][ ]    [2][3][ ][ ]    [1][2][ ][ ]
 [3][2][ ][ ]    [2][1][ ][ ]    [1][0][ ][ ]    [0][3][ ][ ]
 [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]
 [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]
 
*/
class SquareShape: Shape
{
  
  override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>]
  {
    return [
      Orientation.zero:       [(0, 0), (1, 0), (1, 1), (0, 1)],
      Orientation.ninety:     [(1, 0), (1, 1), (0, 1), (0, 0)],
      Orientation.oneEighty:  [(1, 1), (0, 1), (0, 0), (1, 0)],
      Orientation.twoSeventy: [(0, 1), (0, 0), (1, 0), (1, 1)],
    ]
  }
  
  override var bottomBlocksForOrientations: [Orientation: Array<Block>]
  {
    return [
      Orientation.zero:       [blocks[FourthBlockIdx], blocks[ThirdBlockIdx]],
      Orientation.ninety:     [blocks[ThirdBlockIdx], blocks[SecondBlockIdx]],
      Orientation.oneEighty:  [blocks[SecondBlockIdx], blocks[FirstBlockIdx]],
      Orientation.twoSeventy: [blocks[FirstBlockIdx], blocks[FourthBlockIdx]],
    ]
  }
  
}
