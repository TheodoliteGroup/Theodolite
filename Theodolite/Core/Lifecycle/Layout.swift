//
//  Layout.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public class Layout: Hashable, Equatable {
  public let component: Component
  public let size: CGSize
  public let children: [LayoutChild]

  private var intersectionCache: IntersectionCache? = nil
  
  /* 
   Can be used to pass data from layout to mount. Useful if you want to pre-compute something, and then use the
   result.
   
   Canonical example is rendering text. You may want to pass the text artifacts from layout to mount so you don't have
   to do the work of laying out the text again when mounting as an optimization.
   
   The framework will always leave this value nil. You can fill it with whatever you want.
  */
  public let extra: Any?
  
  public init(component: Component,
              size: CGSize,
              children: [LayoutChild],
              extra: Any? = nil) {
    self.component = component
    self.size = size
    self.children = children
    self.extra = extra

    if (children.count > 10) {
      self.intersectionCache = IntersectionCache(layout: self)
    }
  }
  
  static func empty(component: Component) -> Layout {
    return Layout(component: component, size: CGSize(width:0, height:0), children: [])
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
  }
  
  static public func ==(lhs: Layout, rhs: Layout) -> Bool {
    return lhs === rhs
  }
  
  deinit {
    // Tearing down the layout hierarchy is expensive! We dispatch to a background thread to tear down the tree
    // below the top layout.
    if Thread.isMainThread {
      var capturedChildren: [LayoutChild] = self.children
      var intersectionCache = self.intersectionCache
      DispatchQueue.global().async {
        capturedChildren.removeAll()
        // silly, I know, but this is to silence a warning of writing but never reading.
        if intersectionCache != nil {
          intersectionCache = nil
        }
      }
    }
  }

  public func intersectingChildren(rect: CGRect) -> [LayoutChild] {
    if let intersectionCache = self.intersectionCache {
      return intersectionCache.intersectingChildren(rect: rect)
    } else {
      var intersecting: [LayoutChild] = []
      for layoutChild in children {
        let childFrame = CGRect(origin: layoutChild.position,
                                size: layoutChild.layout.size)
        if childFrame.intersects(rect) {
          intersecting.append(layoutChild)
        }
      }
      return intersecting
    }
  }
}

public struct LayoutChild {
  public let layout: Layout
  /** The upper-left origin of the component. Same as frame.origin. */
  public let position: CGPoint
  
  public init(layout: Layout,
              position: CGPoint) {
    self.layout = layout
    self.position = position
  }
}
