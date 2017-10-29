//
//  SnapshotHelper.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 10/24/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
@testable import Theodolite

func snapshotTestComponent(_ testCase: FBSnapshotTestCase, _ size: CGSize, _ identifier: String, mountVisibleOnly: Bool = false, factory: () -> Component) {
  let view = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
  let scopeRoot = ScopeRoot(previousRoot: nil, listener: nil, stateUpdateMap: [:], factory: factory)
  
  let layout = scopeRoot.root.component().layout(constraint: view.bounds.size, tree: scopeRoot.root)
  
  MountRootLayout(view: view,
                  layout: layout,
                  position: CGPoint(x: 0, y: 0),
                  incrementalContext: IncrementalMountContext(),
                  mountVisibleOnly: mountVisibleOnly)
  
  testCase.FBSnapshotVerifyView(view, identifier: identifier)
}

final class ViewComponent: TypedComponent {
  typealias PropType = ViewConfiguration
  
  public func view() -> ViewConfiguration? {
    return self.props
  }
  
  func layout(constraint: CGSize, tree: ComponentTree) -> Layout {
    return Layout(component: self,
                  size: constraint,
                  children: [])
  }
}
