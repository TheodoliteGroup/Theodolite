//
//  IncrementalMountComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/25/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public final class IncrementalMountComponent: TypedComponent {
  public typealias PropType = Component
  
  private var mounted: NSHashTable<Layout> = NSHashTable(options: NSPointerFunctions.Options.objectPointerPersonality, capacity: 4)
  
  public init() {}
  
  public func render() -> [Component?] {
    return [self.props()]
  }
  
  public func mount(parentView: UIView, layout: Layout, position: CGPoint) {
    // Find the components that intersect with the parent's bounds
    let bounds = parentView.bounds
    
    for childLayout in layout.children {
      let childFrame = CGRect(x: position.x + childLayout.position.x,
                              y: position.y + childLayout.position.y,
                              width: childLayout.layout.size.width,
                              height: childLayout.layout.size.height)
      if childFrame.intersects(bounds) {
        if !mounted.contains(childLayout.layout) {
          childLayout.layout.component?.componentWillMount()
          childLayout.layout.component?.mount(parentView: parentView,
                                              layout: childLayout.layout,
                                              position: childFrame.origin)
          childLayout.layout.component?.componentDidMount()
          mounted.add(childLayout.layout)
        }
      } else if mounted.contains(childLayout.layout) {
        childLayout.layout.component?.componentWillUnmount()
        childLayout.layout.component?.unmount(layout: childLayout.layout)
        mounted.remove(childLayout.layout)
      }
    }
  }
  
  public func unmount(layout: Layout) {
    self.componentWillUnmount()
    let enumerator = mounted.objectEnumerator()
    while let layout: Layout = enumerator.nextObject() as? Layout {
      layout.component?.unmount(layout: layout)
    }
  }
}
