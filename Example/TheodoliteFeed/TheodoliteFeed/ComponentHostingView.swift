//
//  ComponentHostingView.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/13/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit
import Theodolite

final class ComponentHostingView: UIView, StateUpdateListener {
  struct CachedLayout {
    let constraint: CGSize
    let layout: Layout
  }
  
  public var factory: () -> Component {
    didSet {
      self.root = ScopeRoot(previousRoot: self.root,
                            listener: self,
                            stateUpdateMap: self.stateUpdateMap,
                            factory: self.factory)
      self.setNeedsLayout()
    }
  }
  
  // MARK: Private properties
  var root: ScopeRoot?
  var lastLayout: CachedLayout?
  var stateUpdateMap: [Int32:Any?]
  var dispatched: Bool
  
  init(factory: @escaping () -> Component) {
    self.factory = factory
    self.stateUpdateMap = [:]
    self.dispatched = false
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    self.root = ScopeRoot(previousRoot: self.root,
                          listener: self,
                          stateUpdateMap: self.stateUpdateMap,
                          factory: self.factory)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // First check if we have a cached layout that is still valid
    if let cachedLayout = self.lastLayout {
      if cachedLayout.constraint == self.bounds.size {
        self.mountLayout(layout: cachedLayout.layout)
        return
      }
    }
    
    if let root = self.root {
      let layout = root.root.component().layout(constraint: self.bounds.size,
                                                tree: root.root)
      self.mountLayout(layout: layout)
      self.lastLayout = CachedLayout(constraint: self.bounds.size, layout: layout)
    }
  }
  
  // MARK: Component generation/mounting
  
  func mountLayout(layout: Layout) {
    layout.component.mount(parentView: self,
                           layout: layout,
                           position: CGPoint(x: 0, y: 0))
  }
  
  func markNeedsReset() {
    assert(Thread.isMainThread)
    if self.dispatched {
      return
    }
    
    self.dispatched = true
    let stateUpdateMap = self.stateUpdateMap
    self.stateUpdateMap.removeAll()
    let previousRoot = self.root
    let factory = self.factory
    let constraint = self.bounds.size
    DispatchQueue.global().async {
      let newRoot = ScopeRoot(previousRoot: previousRoot,
                              listener: self,
                              stateUpdateMap: stateUpdateMap,
                              factory: factory)
      // This is a best-effort layout attempt. We can't guarantee that the hosting view won't change its bounds before
      // we apply our update. When that happens in layoutSubviews, we will throw out this layout and will re-compute
      // using the new bounds.
      let newLayout = newRoot.root.component().layout(constraint: constraint,
                                                      tree: newRoot.root)
      DispatchQueue.main.async(execute: {
        self.dispatched = false
        self.root = newRoot
        self.lastLayout = CachedLayout(constraint: constraint, layout: newLayout)
        self.setNeedsLayout()
        if (self.stateUpdateMap.count > 0) {
          self.markNeedsReset()
        }
      })
    }
  }
  
  // MARK: StateUpdateListener
  
  func receivedStateUpdate(identifier: Int32, update: Any?) {
    assert(Thread.isMainThread)
    self.stateUpdateMap[identifier] = update
    self.markNeedsReset()
  }
}
