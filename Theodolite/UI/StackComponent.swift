//
//  StackComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/13/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public final class StackComponent: TypedComponent {
  public typealias PropType = [Component?]
  
  public init() {}
  
  public func render() -> [Component?] {
    return self.props()
  }
  
  public func layout(constraint: CGSize, tree: ComponentTree) -> Layout {
    var last = CGPoint(x: 0, y: 0)
    var size = CGSize(width: 0, height: 0)
    let children = tree.children().map { (childTree: ComponentTree?) -> LayoutChild in
      if let childLayout =
        childTree?
          .component()
          .layout(constraint: constraint,
                  tree: childTree!) {
        
        let position = last
        last = CGPoint(x: position.x,
                       y: position.y + childLayout.size.height)
        
        size = CGSize(width: max(size.width, childLayout.size.width),
                      height: size.height + childLayout.size.height)
        
        return LayoutChild(
          layout:childLayout,
          position: position)
      } else {
        return LayoutChild(
          layout:
          Layout(
            component: nil,
            size: CGSize(width: 0, height: 0),
            children: []),
          position: last)
      }
    }
    return Layout(
      component: self,
      size: size,
      children: children)
  }
}
