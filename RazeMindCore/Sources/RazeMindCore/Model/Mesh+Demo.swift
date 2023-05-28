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

public extension Mesh {
  static func sampleMesh() -> Mesh {
    let mesh = Mesh()
    mesh.updateNodeText(mesh.rootNode(), string: "every human has a right to")
    [(0, "shelter"),
     (120, "food"),
     (240, "education")].forEach({ (angle, name) in
      let point = mesh.pointWithCenter(center: .zero, radius: 200, angle: angle.radians)
      let node = mesh.addChild(mesh.rootNode(), at: point)
      mesh.updateNodeText(node, string: name)
    })
    return mesh
  }

  static func sampleProceduralMesh() -> Mesh {
    let mesh = Mesh()
    //seed root node with 3 children
    [0, 1, 2, 3].forEach({ index in
      let point = mesh.pointWithCenter(center: .zero, radius: 300, angle: (index * 90 + 30).radians)
      let node = mesh.addChild(mesh.rootNode(), at: point)
      mesh.updateNodeText(node, string: "A\(index + 1)")
      mesh.addChildrenRecursive(to: node, distance: 100, generation: 1)
    })
    return mesh
  }

  func addChildrenRecursive(to node: Node, distance: CGFloat, generation: Int) {
    let labels = ["A", "B", "C", "D", "E", "F"]
    guard generation < labels.count else {
      return
    }

    let childCount = Int.random(in: 1..<4)
    var count = 0
    while count < childCount {
      count += 1
      let position = positionForNewChild(node, length: distance)
      let child = addChild(node, at: position)
      updateNodeText(child, string: "\(labels[generation])\(count + 1)")
      addChildrenRecursive(to: child, distance: distance + 100.0, generation: generation + 1)
    }
  }

}

extension Int {
  var radians: CGFloat {
    CGFloat(self) * CGFloat.pi/180.0
  }
}
