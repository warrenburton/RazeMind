/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import CoreGraphics

extension Mesh {

  public func positionForNewChild(_ parent: Node, length: CGFloat) -> CGPoint {

    let childEdges = edges.filter({ $0.start == parent.id })
    if let grandparentedge = edges.filter({ $0.end == parent.id }).first, let grandparent = nodeWithID(grandparentedge.start) {

      let baseAngle = angleFrom(start: grandparent.position, end: parent.position)
      let childBasedAngle = positionForChildAtIndex(childEdges.count, baseAngle: baseAngle)
      let newpoint = pointWithCenter(center: parent.position, radius: length, angle: childBasedAngle)
      return newpoint
    }
    return CGPoint(x: 200, y: 200)
  }

  func positionForChildAtIndex(_ index: Int, baseAngle: CGFloat) -> CGFloat {
    let jitter = CGFloat.random(in: CGFloat(-1.0)...CGFloat(1.0)) * CGFloat.pi/32.0
    guard index > 0 else { return baseAngle + jitter }

    let level = (index + 1)/2
    let polarity: CGFloat = index % 2 == 0 ? -1.0:1.0

    let delta = CGFloat.pi/6.0 + jitter
    return baseAngle + polarity * delta * CGFloat(level)
  }

  /// angle in radians
  func pointWithCenter(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
    let deltax = radius*cos(angle)
    let deltay = radius*sin(angle)
    let newpoint = CGPoint(x: center.x + deltax, y: center.y + deltay)
    return newpoint
  }

  func angleFrom(start: CGPoint, end: CGPoint) -> CGFloat {
    var deltax = end.x - start.x
    let deltay = end.y - start.y
    if abs(deltax) < 0.001 {
      deltax = 0.001
    }
    let  angle = atan(deltay/abs(deltax))
    return deltax > 0 ? angle: CGFloat.pi - angle
  }

}
