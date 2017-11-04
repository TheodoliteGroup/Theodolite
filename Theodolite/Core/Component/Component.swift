//
//  Component.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

open class Component: UnTypedComponent {
  public required init(doNotCall key: AnyHashable?) {
    self.key = key
  }

  // MARK: Render

  open func render() -> [Component] {
    return []
  }

  // MARK: Layout

  open func layout(constraint: SizeRange, tree: ComponentTree) -> Layout {
    return StandardLayout(component: self, constraint: constraint, tree: tree)
  }

  // MARK: Mount

  /**
   The core mounting algorithm for Components. If you override these methods in your component, you're responsible for
   inspecting that you don't break any other functionality.

   In general, you should *never* override these methods. Instead, override the componentWillMount and related methods.
   */
  open func mount(parentView: UIView, layout: Layout, position: CGPoint) -> MountContext {
    return StandardMountLayout(parentView: parentView,
                               layout: layout,
                               position: position,
                               config: view(),
                               componentContext: self.context)
  }

  open func unmount(layout: Layout) {
    guard let config = self.view() else {
      return
    }
    let context = self.context
    guard let currentView = context.mountInfo.currentView else {
      return
    }

    context.mountInfo.currentView = nil;

    assert(currentView.superview != nil, "You must not remove a Theoodlite-managed view from the hierarchy")
    let superview = currentView.superview!

    let map = ViewPoolMap.getViewPoolMap(view: superview)
    map.checkinView(component: layout.component, parent: superview, config: config, view: currentView)
  }

  open func componentWillMount() {}
  open func componentDidMount() {
    if let view = self.context.mountInfo.currentView {
      // Hide any views that weren't vended from our view (not our parent's, that's their responsibility).
      ViewPoolMap.resetViewPoolMap(view: view)
    }
  }

  open func componentWillUnmount() {}

  open func view() -> ViewConfiguration? {
    return nil
  }

  // MARK: Framework Details q

  public let context = ComponentContext()

  internal let key: AnyHashable?
}
