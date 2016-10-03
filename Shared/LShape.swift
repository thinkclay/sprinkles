/*
 
 0 degrees       90 degrees      180 degrees     270 degrees
 
 [0][ ][ ][ ]    [2][1][0][ ]    [3][2][ ][ ]    [ ][ ][3][ ]
 [1][ ][ ][ ]    [3][ ][ ][ ]    [ ][1][ ][ ]    [0][1][2][ ]
 [2][3][ ][ ]    [ ][ ][ ][ ]    [ ][0][ ][ ]    [ ][ ][ ][ ]
 [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]
 
*/
class LShape: Shape
{
  
  override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>]
  {
    return [
      Orientation.zero:       [(0, 0), (0, 1),  (0, 2), (1, 2)],
      Orientation.ninety:     [(2, 0), (1, 0),  (0, 0), (0, 1)],
      Orientation.oneEighty:  [(1, 2), (1, 1),  (1, 0), (0, 0)],
      Orientation.twoSeventy: [(0, 1), (1, 1),  (2, 1), (2, 0)],
    ]
  }
  
  override var bottomBlocksForOrientations: [Orientation: Array<Block>]
  {
    return [
      Orientation.zero:       [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
      Orientation.ninety:     [blocks[FourthBlockIdx]],
      Orientation.oneEighty:  [blocks[FirstBlockIdx]],
      Orientation.twoSeventy: [blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[ThirdBlockIdx]]
    ]
  }
  
}
