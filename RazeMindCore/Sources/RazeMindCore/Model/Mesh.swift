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

public class Mesh: ObservableObject {
    
    let rootNodeID: NodeID
    @Published public var nodes = [Node]()
    @Published public var links = [EdgeProxy]()

    @Published public var editingText: String
    
    
    public init() {
        editingText = ""
        let root = Node(text: "root")
        rootNodeID = root.id
        addNode(root)
    }
    
    public init(storage: MeshStorageProxy) {
        editingText = ""
        rootNodeID = storage.rootNodeID
        nodes = storage.nodes
        edges = storage.edges
        rebuildLinks()
    }
    
    var edges = [Edge]() {
        didSet {
            rebuildLinks()
        }
    }
    
    func rebuildLinks() {
        links = edges.compactMap({ edge in
            let snode = nodes.filter({ $0.id == edge.start }).first
            let enode = nodes.filter({ $0.id == edge.end }).first
            if let snode = snode, let enode = enode {
                return EdgeProxy(id: edge.id, start: snode.position, end: enode.position)
            }
            return nil
        })
    }
    
    public func rootNode() -> Node {
        guard let root = nodes.filter({ $0.id == rootNodeID }).first else {
            fatalError("mesh is invalid - no root")
        }
        return root
    }
    
    func nodeWithID(_ nodeID: NodeID) -> Node? {
        return nodes.filter({ $0.id == nodeID }).first
    }
    
    func replace(_ node: Node, with replacement: Node) {
        var newSet = nodes.filter({ $0.id != node.id })
        newSet.append(replacement)
        nodes = newSet
    }
    
}



public extension Mesh {
    
    func updateNodeText(_ srcNode: Node, string: String) {
        var newNode = srcNode
        newNode.text = string
        replace(srcNode, with: newNode)
    }
    
    func positionNode(_ node: Node, position: CGPoint) {
        var movedNode = node
        movedNode.position = position
        replace(node, with: movedNode)
        rebuildLinks()
    }
    
    func processNodeTranslation(_ translation: CGSize, nodes: [DragInfo], snapToGrid: Bool = false) {
        nodes.forEach({ draginfo in
            if let node = nodeWithID(draginfo.id) {
                var nextPosition = draginfo.originalPosition.translatedBy(x: translation.width, y: translation.height)
                if snapToGrid {
                    let granularity: CGFloat = 10.0
                    nextPosition.x = (nextPosition.x/granularity).rounded(.toNearestOrEven) * granularity
                    nextPosition.y = (nextPosition.y/granularity).rounded(.toNearestOrEven) * granularity
                }
                positionNode(node, position: nextPosition)
            }
        })
    }
    
    func roundToTens(x : Double) -> Int {
        return 10 * Int(round(x / 10.0))
    }
    
}

public extension Mesh {
    
    func addNode(_ node: Node) {
        nodes.append(node)
    }
    
    func connect(_ parent: Node, to child: Node) {
        
        let newedge = Edge(start: parent.id, end: child.id)
        let exists = edges.contains(where: { edge in
            return newedge == edge
        })
        
        guard exists == false else {
            return
        }
        
        edges.append(newedge)
    }
}

public extension Mesh {
    
    @discardableResult func addChild(_ parent: Node, at point: CGPoint? = nil) -> Node {
        let target = point ?? parent.position
        let child = Node(position: target, text: "child")
        addNode(child)
        connect(parent, to: child)
        rebuildLinks()
        return child
    }
    
    @discardableResult func addSibling(_ node: Node, at point: CGPoint? = nil) -> Node? {
        
        guard node.id != rootNodeID else {
            return nil
        }
        
        let parentedges = edges.filter({ $0.end == node.id })
        if let parentedge = parentedges.first,
           let parentnode = nodeWithID(parentedge.start) {
            let sibling = addChild(parentnode, at: point)
            return sibling
        }
        return nil
    }
    
    func deleteNodes(_ nodesToDelete: [NodeID]) {
        for id in nodesToDelete where id != rootNodeID {
            if let delete = nodes.firstIndex(where: { $0.id == id }) {
                nodes.remove(at: delete)
                let remainingEdges = edges.filter({ $0.end != id && $0.start != id })
                edges = remainingEdges
            }
        }
        rebuildLinks()
    }
    
    func deleteNodes(_ nodesToDelete: [Node]) {
        deleteNodes(nodesToDelete.map({ $0.id }))
    }
    
}

public extension Mesh {
    
    func locateParent(_ node: Node) -> Node? {
        let parentedges = edges.filter({ $0.end == node.id })
        if let parentedge = parentedges.first,
           let parentnode = nodeWithID(parentedge.start) {
            return parentnode
        }
        return nil
    }
    
    func distanceFromRoot(_ node: Node, distance: Int = 0) -> Int? {
        
        if node.id == rootNodeID { return distance }
        
        if let ancestor = locateParent(node) {
            if ancestor.id == rootNodeID {
                return distance + 1
            } else {
                return distanceFromRoot(ancestor, distance: distance + 1)
            }
        }
        return nil
    }
}
