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
  public var factory: () -> Component {
    didSet {
      self.resetRoot()
      self.setNeedsLayout()
    }
  }
  
  var root: ScopeRoot?
  var stateUpdateMap: [Int32:Any?]
  var dispatched: Bool
  
  init(factory: @escaping () -> Component) {
    self.factory = factory
    self.stateUpdateMap = [:]
    self.dispatched = false
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    self.resetRoot()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if let root = self.root {
      let layout = root.root.component().layout(constraint: self.bounds.size,
                                                tree: root.root)
      root.root.component().mount(parentView: self,
                                  layout: layout,
                                  position: CGPoint(x: 0, y: 0))
    }
  }
  
  func resetRoot() {
    assert(Thread.isMainThread)
    self.root = ScopeRoot(previousRoot: self.root,
                          listener: self,
                          stateUpdateMap: self.stateUpdateMap,
                          factory: self.factory)
  }
  
  func markNeedsReset() {
    assert(Thread.isMainThread)
    if self.dispatched {
      return
    }
    
    self.dispatched = true
    DispatchQueue.main.async(execute: {
      self.dispatched = false
      self.resetRoot()
    })
  }
  
  // MARK: StateUpdateListener
  
  func receivedStateUpdate(identifier: Int32, update: Any?) {
    assert(Thread.isMainThread)
    self.stateUpdateMap[identifier] = update
    self.markNeedsReset()
  }
}
