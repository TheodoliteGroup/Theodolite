//
//  ComponentLayout.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/29/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

public extension Component {
  
  /** The standard layout algorithm that memoizes by default. */
  public func layout(constraint: CGSize, tree: ComponentTree) -> Layout {
    // Check if we can memoize our layout. If you're building your own component layout, you can probably skip this.
    // Instead, just add an empty component in the hierarchy that is a parent of your heavy layout components, and
    // they'll memoize for you instead of duplicating this code.
    let componentContext = GetContext(self)
    if let componentContext = componentContext {
      if let cachedLayout = MemoizedLayout(component: self,
                                           componentContext: componentContext,
                                           constraint: constraint) {
        return cachedLayout
      }
    }
    
    // No memoized layout, we gotta compute fresh.
    let layoutChildren = tree.children().map { (childTree: ComponentTree) -> LayoutChild in
      return LayoutChild(
        layout:childTree
          .component()
          .layout(constraint: constraint,
                  tree: childTree),
        position: CGPoint(x: 0, y: 0))
    }
    
    // We assume that our size is the union of all child frames, but it doesn't have to be.
    let contentRect = layoutChildren.reduce(
      CGRect.null,
      { (unionRect, layoutChild) -> CGRect in
        return unionRect.union(CGRect(origin: layoutChild.position,
                                      size: layoutChild.layout.size))
    })
    
    let layout = Layout(
      component: self,
      size: contentRect.size,
      children: layoutChildren)
    
    if let componentContext = componentContext {
      // Cache the layout so that we can hit the cache if we get asked about this right away.
      StoreLayout(layout: layout,
                  componentContext: componentContext,
                  constraint: constraint)
    }
    return layout
  }
}

internal func MemoizedLayout(component: Component,
                             componentContext: ComponentContextProtocol,
                             constraint: CGSize) -> Layout? {
  if let previousLayoutInfo = componentContext.layoutInfo.get() {
    if SizesEqual(constraint, previousLayoutInfo.constraint) {
      return Layout(component: component,
                    size: previousLayoutInfo.size,
                    children: previousLayoutInfo.children,
                    extra: previousLayoutInfo.extra)
    }
  }
  return nil
}

internal func StoreLayout(layout: Layout,
                          componentContext: ComponentContextProtocol,
                          constraint: CGSize) {
  componentContext.layoutInfo.update({ (_) in
    LayoutInfo(constraint: constraint,
               size: layout.size,
               children: layout.children,
               extra: layout.extra) })
}
