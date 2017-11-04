//
//  Component.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

/**
 The superclass of all Components.

 This class provides the core, untyped API of Components. You subclass it, and override functions
 */
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
   What is mounting?

   Mounting is the process by which component hierarchies attach to views. If you're used to working with collection
   views, it's similar in concept to re-configuring cells in cellForItemAt... Components check out views from the
   reuse pools in mount, configure them with a collection of attributes (bg color, etc), and then return the information
   needed to mount the component's children.
   */

  /**
   Mount: Attach your component to a view hierarchy.

   The normal algorithm can be found in StandardMountLayout().

   In general, you should not override these methods unless you're doing something really advanced. Instead, override
   the componentWillMount and related methods.
   */
  open func mount(parentView: UIView, layout: Layout, position: CGPoint) -> MountContext {
    return StandardMountLayout(parentView: parentView,
                               layout: layout,
                               position: position,
                               config: view(),
                               componentContext: self.context)
  }

  /**
   Unmount: Detach your component from the view hierarchy

   If you override this method, you **have to remember to check back in your view into the reuse pools**, or just call
   super.unmount(layout: layout) before returning.

   Generally, prefer to override componentWillUnmount() instead since it's much less tricky to get right.
   */
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

  /** Allows your component to state what type of view it should have, if any. */
  open func view() -> ViewConfiguration? {
    return nil
  }

  // MARK: Framework Details

  /**
   You probably shouldn't ever need to call this, but it provides information on the currently mounted view, and
   the last built layout.
   */
  public let context = ComponentContext()
  internal let key: AnyHashable?
}
