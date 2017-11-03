//
//  PullToRefreshComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/3/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit
import Theodolite

final class PullToRefreshComponent: TypedComponent {
  let context = ComponentContext()
  typealias PropType = (
    action: Action<UIRefreshControl>,
    component: Component
  )
  typealias StateType = Bool

  var refreshControl: UIRefreshControl? = nil

  func render() -> [Component] {
    return [props.component]
  }

  func refreshControlConfig() -> ViewConfiguration! {
    return ViewConfiguration(view: UIRefreshControl.self, attributes: [])
  }

  func mount(parentView: UIView, layout: Layout, position: CGPoint) -> MountContext {
    // Traverse up until we find a scroll view
    var parent: UIView? = parentView
    while parent != nil && !(parent?.isKind(of: UIScrollView.self) ?? false) {
      parent = parent?.superview
    }

    let standardMountClosure = {
      return StandardMountLayout(parentView: parentView,
                                 layout: layout,
                                 position: position,
                                 config: nil,
                                 componentContext: self.context)
    }

    guard let scrollView = parent as? UIScrollView else {
      // Pull-to-refresh doesn't make sense without a scroll view
      assertionFailure("Pull to refresh component isn't in a scroll view")
      return standardMountClosure()
    }

    let map = ViewPoolMap.getViewPoolMap(view: scrollView)
    let view = map
      .checkoutView(component: self, parent: scrollView,
                    config: refreshControlConfig()) as! UIRefreshControl
    view.addTarget(self, action: #selector(didPullToRefresh), for: UIControlEvents.valueChanged)

    if view.isRefreshing && state != nil {
      view.endRefreshing()
      view.isHidden = true
    }

    context.mountInfo.currentView = view
    refreshControl = view

    return standardMountClosure()
  }

  func componentWillUnmount() {
    assert(refreshControl != nil)
    guard let refreshControl = self.refreshControl else {
      return
    }
    refreshControl.removeTarget(self, action: #selector(didPullToRefresh), for: UIControlEvents.valueChanged)
    refreshControl.isHidden = true
    let scrollView = refreshControl.superview!
    let map = ViewPoolMap.getViewPoolMap(view: scrollView)
    map.checkinView(component: self,
                    parent: scrollView,
                    config: refreshControlConfig(),
                    view: refreshControl)
  }

  @objc func didPullToRefresh() {
    self.updateState(state: true)
    props.action.send(refreshControl!)
  }
}
