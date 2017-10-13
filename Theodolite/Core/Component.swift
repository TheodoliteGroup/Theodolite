//
//  Component.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public protocol Component: class {
  init();
  
  /** Core methods */
  func render() -> [Component]?;
  func mount(parentView: UIView, layout: Layout, position: CGPoint);
  func unmount();
  func layout(constraint: CGSize) -> Layout;
  
  /** Lifecycle methods */
  
  /** Finalize: finished layout, and is now available for rendering */
  func componentDidFinalize(layout: Layout);
  
  /** Mount: attaching to a view */
  func componentWillMount();
  func componentDidMount();

  /** Unmount: detaching from a view */
  func componentWillUnmount();
  
  /** Used to identify the component so it can be associated with its prior state. */
  func key() -> AnyHashable?;
}

extension Component {
  public func render() -> [Component]? {
    return nil;
  }
  public func mount(parentView: UIView, layout: Layout, position: CGPoint) {
    self.componentWillMount();
    for childLayout in layout.children {
      childLayout.layout.component.mount(parentView: parentView,
                                         layout: childLayout.layout,
                                         position: CGPoint(x: childLayout.position.x + position.x,
                                                           y: childLayout.position.y + position.y));
    }
    self.componentDidMount();
  }
  public func unmount() {
    self.componentWillUnmount();
  }
  public func layout(constraint: CGSize) -> Layout {
    return Layout(component: self,
                  size: CGSize(width: 0, height:0),
                  children: []);
  }
  
  public func componentDidFinalize(layout: Layout) {}
  
  public func componentWillMount() {}
  public func componentDidMount() {}
  
  public func componentWillUnmount() {}
  
  public func key() -> AnyHashable? {
    return nil;
  }
}
