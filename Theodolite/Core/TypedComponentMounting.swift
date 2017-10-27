//
//  TypedComponentMounting.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/25/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

public extension TypedComponent {
  func view() -> ViewConfiguration? {
    return nil
  }
  
  /**
   The core mounting algorithm for Components. If you override these methods in your component, you're responsible for
   inspecting that you don't break any other functionality.
   
   In general, you should *never* override these methods. Instead, override the componentWillMount and related methods.
   */
  func mount(parentView: UIView, layout: Layout, position: CGPoint) -> MountContext {
    return StandardMountLayout(parentView: parentView,
                               layout: layout,
                               position: position,
                               config: view(),
                               componentContext: context())
  }
  
  func componentDidMount() {
    if let view = context().mountInfo.currentView {
      // Hide any views that weren't vended from our view (not our parent's, that's their responsibility).
      ViewPoolMap.resetViewPoolMap(view: view)
    }
  }
  
  public func unmount(layout: Layout) {
    guard let config = self.view() else {
      return
    }
    let context = self.context()
    guard let currentView = context.mountInfo.currentView else {
      return
    }
    
    context.mountInfo.currentView = nil;
    
    assert(currentView.superview != nil, "You must not remove a Theoodlite-managed view from the hierarchy")
    let superview = currentView.superview!
    
    let map = ViewPoolMap.getViewPoolMap(view: superview)
    map.checkinView(parent: superview, config: config, view: currentView)
  }
}

internal func StandardMountLayout<PropType, ViewType>(parentView: UIView,
                                            layout: Layout,
                                            position: CGPoint,
                                            config: ViewConfiguration?,
                                            componentContext: ComponentContext<PropType, ViewType>) -> MountContext {
  guard let config = config else {
    return MountContext(view: parentView,
                        position: position,
                        shouldMountChildren: true)
  }
  
  let map = ViewPoolMap.getViewPoolMap(view: parentView)
  let view = map
    .checkoutView(parent: parentView, config: config)!
  componentContext.mountInfo.currentView = view as? ViewType
  view.frame = CGRect(x: position.x,
                      y: position.y,
                      width: layout.size.width,
                      height: layout.size.height)
  
  return MountContext(view: view,
                      position: CGPoint(x: 0, y: 0),
                      shouldMountChildren: true)
}
