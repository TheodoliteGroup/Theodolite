//
//  ScrollComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/26/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public protocol ScrollListener: AnyObject {
  func scrollViewDidScroll(scrollView: UIScrollView)
}

public final class ScrollComponent: TypedComponent {
  public typealias PropType = (
    Component,
    direction: UICollectionViewScrollDirection,
    attributes: [Attribute]
  )
  public typealias ViewType = UIScrollView
  
  private var scrollDelegate: InternalScrollDelegate? = nil
  
  public init() {}
  
  public func view() -> ViewConfiguration? {
    return ViewConfiguration(view: UIScrollView.self,
                             attributes: self.props().attributes)
  }
  
  public func layout(constraint: CGSize, tree: ComponentTree) -> Layout {
    let direction = self.props().direction
    let children = tree.children().map { (childTree: ComponentTree) -> LayoutChild in
      return LayoutChild(
        layout:childTree
          .component()
          .layout(constraint:
            direction == UICollectionViewScrollDirection.vertical
              ? CGSize(width: constraint.width,
                       height: CGFloat.greatestFiniteMagnitude)
              : CGSize(width: CGFloat.greatestFiniteMagnitude,
                       height: constraint.height),
                  tree: childTree),
        position: CGPoint(x: 0, y: 0))
    }
    
    let contentSize = children.reduce(
      CGRect(x: 0, y: 0, width: 0, height: 0),
      { (unionRect, layoutChild) -> CGRect in
        return unionRect.union(CGRect(origin: layoutChild.position,
                                      size: layoutChild.layout.size))
    })
    
    return Layout(
      component: self,
      size: direction == UICollectionViewScrollDirection.vertical
        ? CGSize(width: contentSize.width, height: constraint.height)
        : CGSize(width: constraint.width, height: contentSize.height),
      children: children,
      extra: contentSize)
  }
  
  public func mount(parentView: UIView,
                    layout: Layout,
                    position: CGPoint) -> MountContext {
    let mountContext = StandardMountLayout(parentView: parentView,
                                           layout: layout,
                                           position: position,
                                           config: self.view(),
                                           componentContext: self.context())
    
    let scrollView = mountContext.view as! UIScrollView
    scrollDelegate = InternalScrollDelegate(layout: layout)
    scrollView.delegate = scrollDelegate
    scrollView.contentSize = layout.extra as! CGSize
    
    return mountContext
  }
  
  public func componentWillUnmount() {
    let scrollView = context().mountInfo.currentView
    scrollView?.delegate = nil
  }
}

@objc private class InternalScrollDelegate: NSObject, UIScrollViewDelegate {
  weak var layout: Layout?
  
  init(layout: Layout) {
    self.layout = layout
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let layout = self.layout else {
      return
    }
    announce(layout: layout) { (listener: ScrollListener) in
      listener.scrollViewDidScroll(scrollView: scrollView)
    }
  }
  
  private func announce(layout: Layout, closure: (ScrollListener) -> ()) {
    if let listener = layout.component as? ScrollListener {
      closure(listener)
    }
    layout.children.forEach { (layoutChild: LayoutChild) in
      announce(layout: layoutChild.layout, closure: closure)
    }
  }
}
