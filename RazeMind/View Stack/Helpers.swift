//
//  Helpers.swift
//  Spiral3
//
//  Created by Warren Burton on 18/11/2019.
//  Copyright © 2019 Warren Burton. All rights reserved.
//

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
