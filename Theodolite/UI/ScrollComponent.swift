//
//  ScrollComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/26/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public final class ScrollComponent: TypedComponent, ScrollListener {
  public typealias PropType = (
    Component,
    direction: UICollectionViewScrollDirection,
    attributes: [Attribute]
  )
  public typealias ViewType = UIScrollView
  
  private var scrollDelegate: InternalScrollDelegate? = nil
  private var mountedArguments: (parentView: UIView, layout: Layout, position: CGPoint)? = nil
  private var incrementalMountContext: IncrementalMountContext = IncrementalMountContext()
  
  public init() {}
  
  public func render() -> [Component] {
    return [self.props().0]
  }
  
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
                       height: nan("unconstrained"))
              : CGSize(width: nan("unconstrained"),
                       height: constraint.height),
                  tree: childTree),
        position: CGPoint(x: 0, y: 0))
    }
    
    let contentRect = children.reduce(
      CGRect(x: 0, y: 0, width: 0, height: 0),
      { (unionRect, layoutChild) -> CGRect in
        return unionRect.union(CGRect(origin: layoutChild.position,
                                      size: layoutChild.layout.size))
    })
    
    return Layout(
      component: self,
      size: direction == UICollectionViewScrollDirection.vertical
        ? CGSize(width: contentRect.size.width, height: constraint.height)
        : CGSize(width: constraint.width, height: contentRect.size.height),
      children: children,
      extra: contentRect.size)
  }
  
  public func mount(parentView: UIView,
                    layout: Layout,
                    position: CGPoint) -> MountContext {
    mountedArguments = (parentView: parentView, layout: layout, position: position)
    
    let mountContext = StandardMountLayout(parentView: parentView,
                                           layout: layout,
                                           position: position,
                                           config: self.view(),
                                           componentContext: self.context())
    
    let scrollView = mountContext.view as! UIScrollView
    scrollDelegate = InternalScrollDelegate(layout: layout)
    scrollView.delegate = scrollDelegate
    scrollView.contentSize = layout.extra as! CGSize
    
    // Now we mount our children
    let componentContext = context()
    // todo: this is terrible, need to fix it
    componentContext.untypedMountInfo.mountContext = mountContext
    mountChildren()
    
    return MountContext(view: mountContext.view,
                        position: mountContext.position,
                        shouldMountChildren: false)
  }
  
  public func componentWillUnmount() {
    let scrollView = context().mountInfo.currentView
    scrollView?.delegate = nil
    
    guard let mountedArguments = mountedArguments else {
      return
    }
    UnmountLayout(layout: mountedArguments.layout,
                  incrementalContext: incrementalMountContext)
  }
  
  private func mountChildren() {
    guard let mountedArguments = mountedArguments else {
      return
    }
    MountRootLayout(view: context().mountInfo.mountContext!.view,
                    layout: mountedArguments.layout.children[0].layout,
                    position: context().mountInfo.mountContext!.position,
                    incrementalContext: incrementalMountContext,
                    mountVisibleOnly: true)
  }
  
  // MARK: ScrollListener
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    mountChildren()
  }
}

private protocol ScrollListener: AnyObject {
  func scrollViewDidScroll(scrollView: UIScrollView)
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
    // TODO: see if we should traverse
  }
}
