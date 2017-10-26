//
//  MountContext.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/25/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

public struct MountContext {
  /** The view that children should receive as their parent. */
  let view: UIView
  let position: CGPoint
}

public class IncrementalMountContext {
  private var mounted: NSHashTable<Layout> =
    NSHashTable(options: NSPointerFunctions.Options.objectPointerPersonality,
                capacity: 4)
  private var marked: NSHashTable<Layout> =
    NSHashTable(options: NSPointerFunctions.Options.objectPointerPersonality,
                capacity: 4)
  
  public func isMounted(layout: Layout) -> Bool {
    return mounted.contains(layout)
  }
  
  public func markMounted(layout: Layout) {
    mounted.add(layout)
    marked.add(layout)
  }
  
  public func markUnmounted(layout: Layout) {
    mounted.remove(layout)
    marked.remove(layout)
  }
  
  public func unmarkedMounted() -> [Layout] {
    if mounted.count == 0 {
      return []
    }
    let copiedHashTable: NSHashTable<Layout> = mounted.copy() as! NSHashTable<Layout>
    copiedHashTable.minus(marked)
    return copiedHashTable.allObjects
  }
  
  public func enumerate(_ closure: (Layout) -> ()) {
    let enumerator = mounted.objectEnumerator()
    while let layout: Layout = enumerator.nextObject() as? Layout {
      closure(layout)
    }
  }
}

public func UnmountLayout(layout: Layout,
                          incrementalContext: IncrementalMountContext) {
  // Call willUnmount before recurring
  layout.component?.componentWillUnmount()
  
  for childLayout in layout.children {
    if (incrementalContext.isMounted(layout: layout)) {
      UnmountLayout(layout: childLayout.layout,
                    incrementalContext: incrementalContext)
    }
  }
  
  incrementalContext.markUnmounted(layout: layout)
  
  // Only unmount **after** all children are unmounted.
  layout.component?.unmount(layout: layout)
  if let component = layout.component {
    GetWrapper(component)?.mountContext = nil
  }
}

public func MountRootLayout(view: UIView,
                            layout: Layout,
                            position: CGPoint,
                            incrementalContext: IncrementalMountContext) {
  MountLayout(view: view,
              layout: layout,
              position: position,
              incrementalContext: incrementalContext)
  
  let toBeUnmounted = incrementalContext.unmarkedMounted()
  for unmountingLayout in toBeUnmounted {
    UnmountLayout(layout: unmountingLayout, incrementalContext: incrementalContext)
  }
}

internal func MountLayout(view: UIView,
                          layout: Layout,
                          position: CGPoint,
                          incrementalContext: IncrementalMountContext) {
  guard let component = layout.component else {
    return
  }
  
  if !incrementalContext.isMounted(layout: layout) {
    component.componentWillMount()
    let context = component.mount(parentView: view,
                                  layout: layout,
                                  position: position)
    GetWrapper(component)?.mountContext = context
    component.componentDidMount()
  }
  
  incrementalContext.markMounted(layout: layout)
  
  guard let context: MountContext = GetWrapper(layout.component)?.mountContext else {
    return
  }
  
  let bounds = context.view.bounds
  
  for childLayout in layout.children {
    let childFrame = CGRect(x: context.position.x + childLayout.position.x,
                            y: context.position.y + childLayout.position.y,
                            width: childLayout.layout.size.width,
                            height: childLayout.layout.size.height)
    if childFrame.intersects(bounds) {
      // Recur into this layout's children
      MountLayout(view: context.view,
                  layout: childLayout.layout,
                  position: CGPoint(x: context.position.x + childLayout.position.x,
                                    y: context.position.y + childLayout.position.y),
                  incrementalContext: incrementalContext)
    } else if incrementalContext.isMounted(layout: childLayout.layout) {
      UnmountLayout(layout: childLayout.layout, incrementalContext: incrementalContext)
    }
  }
}
