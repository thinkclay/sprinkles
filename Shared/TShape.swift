/*
 
 0 degrees       90 degrees      180 degrees     270 degrees
 
 [ ][0][ ][ ]    [ ][1][ ][ ]    [ ][ ][ ][ ]    [ ][3][ ][ ]
 [1][2][3][ ]    [ ][2][0][ ]    [3][2][1][ ]    [0][2][ ][ ]
 [ ][ ][ ][ ]    [ ][3][ ][ ]    [ ][0][ ][ ]    [ ][1][ ][ ]
 [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]    [ ][ ][ ][ ]
 
*/
class TShape: Shape
{
 
  override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>]
  {
    return [
      Orientation.zero:       [(1, 0), (0, 1), (1, 1), (2, 1)],
      Orientation.ninety:     [(2, 1), (1, 0), (1, 1), (1, 2)],
      Orientation.oneEighty:  [(1, 2), (2, 1), (1, 1), (0, 1)],
      Orientation.twoSeventy: [(0, 1), (1, 2), (1, 1), (1, 0)],
    ]
  }
  
  override var bottomBlocksForOrientations: [Orientation: Array<Block>]
  {
    return [
      Orientation.zero:       [blocks[SecondBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
      Orientation.ninety:     [blocks[FirstBlockIdx], blocks[FourthBlockIdx]],
      Orientation.oneEighty:  [blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
      Orientation.twoSeventy: [blocks[FirstBlockIdx], blocks[FourthBlockIdx]]
    ]
  }

}
