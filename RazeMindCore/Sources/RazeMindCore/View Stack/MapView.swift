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

import SwiftUI

struct MapView: View {
  
  @ObservedObject var selection: SelectionHandler
  @ObservedObject var mesh: Mesh
  
    var body: some View {
        ZStack {
          EdgeMapView(edges: $mesh.links)
          NodeMapView(selection: selection, nodes: $mesh.nodes)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let mesh = Mesh()
        let child1 = Node(position: CGPoint(x: 100, y: 200), text: "child 1")
        let child2 = Node(position: CGPoint(x: -100, y: 200), text: "child 2")
        [child1, child2].forEach {
          mesh.addNode($0)
          mesh.connect(mesh.rootNode(), to: $0)
        }
        mesh.connect(child1, to: child2)
        let selection = SelectionHandler()
        return MapView(selection: selection, mesh: mesh)
    }
}
