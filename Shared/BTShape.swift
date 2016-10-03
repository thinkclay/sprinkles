/*
 
 0 degrees       90 degrees      180 degrees     270 degrees
 
 [0][1][2][ ]    [ ][ ][0][ ]    [ ][4][ ][ ]    [2][ ][ ][ ]
 [ ][3][ ][ ]    [4][3][1][ ]    [ ][3][ ][ ]    [1][3][4][ ]
 [ ][4][ ][ ]    [ ][ ][2][ ]    [2][1][0][ ]    [0][ ][ ][ ]
 [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]
 
 */
class BTShape: Shape
{
  
  override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>]
  {
    return [
      Orientation.zero:       [(0, 0), (1, 0), (2, 0), (1, 1), (1, 2)],
      Orientation.ninety:     [(2, 0), (2, 1), (2, 2), (1, 1), (0, 1)],
      Orientation.oneEighty:  [(2, 2), (1, 2), (0, 2), (1, 1), (1, 0)],
      Orientation.twoSeventy: [(0, 2), (0, 1), (0, 0), (1, 1), (2, 1)],
    ]
  }
  
  override var bottomBlocksForOrientations: [Orientation: Array<Block>]
  {
    return [
      Orientation.zero:       [blocks[FirstBlockIdx], blocks[FifthBlockIdx], blocks[ThirdBlockIdx]],
      Orientation.ninety:     [blocks[FifthBlockIdx], blocks[FourthBlockIdx], blocks[ThirdBlockIdx]],
      Orientation.oneEighty:  [blocks[ThirdBlockIdx], blocks[SecondBlockIdx], blocks[FirstBlockIdx]],
      Orientation.twoSeventy: [blocks[FirstBlockIdx], blocks[FourthBlockIdx], blocks[FifthBlockIdx]],
    ]
  }
  
}
