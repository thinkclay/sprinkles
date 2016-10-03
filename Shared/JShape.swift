/*
 
 0 degrees       90 degrees      180 degrees     270 degrees
 
 [ ][0][ ][ ]    [3][ ][ ][ ]    [2][3][ ][ ]    [0][1][2][ ]
 [ ][1][ ][ ]    [2][1][0][ ]    [1][ ][ ][ ]    [ ][ ][3][ ]
 [3][2][ ][ ]    [ ][ ][ ][ ]    [0][ ][ ][ ]    [ ][ ][ ][ ]
 [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]
 
 */
class JShape: Shape
{
  
  override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>]
  {
    return [
      Orientation.zero:       [(1, 0), (1, 1),  (1, 2),  (0, 2)],
      Orientation.ninety:     [(2, 1), (1, 1),  (0, 1),  (0, 0)],
      Orientation.oneEighty:  [(0, 2), (0, 1),  (0, 0),  (1, 0)],
      Orientation.twoSeventy: [(0, 0), (1, 0),  (2, 0),  (2, 1)]
    ]
  }
  
  override var bottomBlocksForOrientations: [Orientation: Array<Block>]
  {
    return [
      Orientation.zero:       [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
      Orientation.ninety:     [blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[ThirdBlockIdx]],
      Orientation.oneEighty:  [blocks[FirstBlockIdx], blocks[FourthBlockIdx]],
      Orientation.twoSeventy: [blocks[ThirdBlockIdx]],
    ]
  }
  
}
