#if os(macOS)
  import AppKit
  typealias Color = NSColor
  typealias BezierPath = NSBezierPath
#else
  import UIKit
  typealias Color = UIColor
  typealias BezierPath = UIBezierPath
#endif
