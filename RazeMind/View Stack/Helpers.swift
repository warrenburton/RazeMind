//MIT License
//
//Copyright (c) [2020] [Warren Burton]
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import SwiftUI

struct Helpers: View {
  
  @ObservedObject var mesh: Mesh
  @ObservedObject var selection: SelectionHandler
  
  func onlySelectedNode() -> Node? {
    return selection.onlySelectedNode(in: mesh)
  }
  
  var onlyOneNodeSelected: Bool {
    return selection.onlySelectedNode(in: mesh) != nil
  }
  
  var rootNodeSelected: Bool {
    if let node = self.onlySelectedNode() {
      return node == mesh.rootNode()
    }
    return false
  }
  
  var canAddSibling: Bool {
    if let _ = self.onlySelectedNode(), rootNodeSelected == false {
      return true
    }
    return false
  }
  
  
  var body: some View {
    ZStack {
      HStack(spacing: 16.0) {
        Button(action: {
          if let parent = self.onlySelectedNode() {
            let position = self.mesh.positionForNewChild(parent, length: 300)
            let child = self.mesh.addChild(parent, at: position)
            self.selection.selectNode(child)
          }
        }) {
          HStack {
            Text("Add Child")
            Image(systemName: "arrow.turn.right.down")
          }
          .padding(8.0)
          .overlay(
            RoundedRectangle(cornerRadius: 5)
              .stroke(self.onlyOneNodeSelected ? Color.purple:Color.gray, lineWidth: 5)
          )
          
        }
        .foregroundColor(self.onlyOneNodeSelected ? Color.purple:Color.gray)
        Button(action: {
          if let node = self.onlySelectedNode(),
            self.canAddSibling,
            let parent = self.mesh.locateParent(node) {
            if let sibling = self.mesh.addSibling(node) {
              let position = self.mesh.positionForNewChild(parent, length: 300)
              self.mesh.positionNode(sibling, position: position)
              self.selection.selectNode(sibling)
            }
          }
        }) {
          HStack {
            Text("Add Sibling")
            Image(systemName: "arrow.turn.down.right")
          }
          .padding(8.0)
          .overlay(
            RoundedRectangle(cornerRadius: 5)
              .stroke(self.canAddSibling ? Color.green:Color.gray, lineWidth: 5)
          )
        }
        .foregroundColor(self.canAddSibling ? Color.green:Color.gray)
        Button(action: {
          let selectedNodes = self.selection.selectedNodes(in: self.mesh)
          self.mesh.deleteNodes(selectedNodes)
        }) {
          HStack {
            Text("Delete Node")
            Image(systemName: "trash")
          }
          .padding(8.0)
          .overlay(
            RoundedRectangle(cornerRadius: 5)
              .stroke(self.onlyOneNodeSelected && rootNodeSelected == false ?  Color.red: Color.gray, lineWidth: 5)
          )
        }
        .foregroundColor(self.onlyOneNodeSelected && rootNodeSelected == false ?  Color.red: Color.gray)
      }
      .padding(8.0)
    }
  }
}

struct Helpers_Previews: PreviewProvider {
  
  @State static var mesh = Mesh()
  @State static var selection = SelectionHandler()
  
  static var previews: some View {
    Helpers(mesh: mesh, selection: selection)
  }
}
