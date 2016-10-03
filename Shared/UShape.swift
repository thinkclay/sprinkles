/*
 
 0 degrees       90 degrees      180 degrees     270 degrees
 
 [0][ ][4][ ]    [1][0][ ][ ]    [3][2][1][ ]    [4][3][ ][ ]
 [1][2][3][ ]    [2][ ][ ][ ]    [4][ ][0][ ]    [ ][2][ ][ ]
 [ ][ ][ ][ ]    [3][4][ ][ ]    [ ][ ][ ][ ]    [0][1][ ][ ]
 [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]
 
*/
class UShape: Shape
{
  
  override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>]
  {
    return [
      Orientation.zero:       [(0, 0), (0, 1), (1, 1), (2, 1), (2, 0)],
      Orientation.ninety:     [(1, 0), (0, 0), (0, 1), (0, 2), (1, 2)],
      Orientation.oneEighty:  [(2, 1), (2, 0), (1, 0), (0, 0), (0, 1)],
      Orientation.twoSeventy: [(0, 2), (1, 2), (1, 1), (1, 0), (0, 0)],
    ]
  }
  
  override var bottomBlocksForOrientations: [Orientation: Array<Block>]
  {
    return [
      Orientation.zero:       [blocks[SecondBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
      Orientation.ninety:     [blocks[FourthBlockIdx], blocks[FifthBlockIdx]],
      Orientation.oneEighty:  [blocks[FifthBlockIdx], blocks[ThirdBlockIdx], blocks[FirstBlockIdx]],
      Orientation.twoSeventy: [blocks[FirstBlockIdx], blocks[SecondBlockIdx]],
    ]
  }
  
}
