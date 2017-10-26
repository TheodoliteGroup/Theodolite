//
//  Component.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public protocol Component: class {
  init()
  
  /** Core methods */
  func render() -> [Component?]
  func mount(parentView: UIView, layout: Layout, position: CGPoint)
  func unmount(layout: Layout)
  func size(constraint: CGSize) -> CGSize
  func layout(constraint: CGSize, tree: ComponentTree) -> Layout
  
  /** Lifecycle methods */
  
  /** Finalize: finished layout, and is now available for rendering */
  func componentDidFinalize(layout: Layout)
  
  /** Mount: attaching to a view */
  func componentWillMount()
  func componentDidMount()

  /** Unmount: detaching from a view */
  func componentWillUnmount()
  
  /** Used to identify the component so it can be associated with its prior state. */
  func key() -> AnyHashable?
}

extension Component {
  public func render() -> [Component?] {
    return []
  }
  
  public func mount(parentView: UIView, layout: Layout, position: CGPoint) {
    self.componentWillMount()
    for childLayout in layout.children {
      if let component = childLayout.layout.component {
        component.mount(parentView: parentView,
                        layout: childLayout.layout,
                        position: CGPoint(x: childLayout.position.x + position.x,
                                          y: childLayout.position.y + position.y))
      }
    }
    self.componentDidMount()
  }
  
  public func unmount(layout: Layout) {
    self.componentWillUnmount()
    for childLayout in layout.children {
      if let component = childLayout.layout.component {
        component.unmount(layout: childLayout.layout)
      }
    }
  }
  
  public func size(constraint: CGSize) -> CGSize {
    return CGSize(width: 0, height: 0)
  }
  
  public func layout(constraint: CGSize, tree: ComponentTree) -> Layout {
    return Layout(
      component: self,
      size: self.size(constraint: constraint),
      children:
      tree.children().map { (childTree: ComponentTree?) -> LayoutChild in
        return LayoutChild(
          layout:childTree?
            .component()
            .layout(constraint: constraint,
                    tree: childTree!) ?? Layout(component: nil,
                                               size: CGSize(width: 0, height: 0),
                                               children: []),
          position: CGPoint(x: 0, y: 0))
    })
  }
  
  public func componentDidFinalize(layout: Layout) {}
  
  public func componentWillMount() {}
  public func componentDidMount() {}
  
  public func componentWillUnmount() {}
  
  public func key() -> AnyHashable? {
    return nil
  }
}
