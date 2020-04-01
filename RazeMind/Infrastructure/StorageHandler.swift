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

import UIKit

/// Encapsulates file ops for the mesh data
class StorageHandler {
  
  let documentURL = UIApplication.documentsDirectory().appendingPathComponent("default.rwmesh")
  
  /// save mesh data to a single file
  func save(_ mesh: MeshStorageProxy) throws {
    let data = try JSONEncoder().encode(mesh)
    try data.write(to: documentURL)
  }
  
  func restore() -> MeshStorageProxy {
    do {
      let data = try Data(contentsOf: documentURL)
      let proxy = try JSONDecoder().decode(MeshStorageProxy.self , from: data)
      return proxy
    } catch {
      DLog("*** oh no! restore error (pass to error system in full impl) -", error)
    }
    return Mesh().storageObject
  }
  
}
