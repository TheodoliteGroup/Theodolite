//
//  InsetComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/28/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

public final class InsetComponent: TypedComponent {
  public typealias PropType = (
    insets: UIEdgeInsets,
    component: Component
  )
  
  public init () {}
  
  public func render() -> [Component] {
    return [self.props().component]
  }
  
  public func layout(constraint: CGSize, tree: ComponentTree) -> Layout {
    let insets = self.props().insets
    let childTree = tree.children()[0]
    let childLayout = childTree
      .component()
      .layout(constraint:
        CGSize(
          width: constraint.width.isNaN
            ? CGFloat.nan
            : max(constraint.width - insets.left - insets.right, 0),
          height: constraint.height.isNaN
            ? CGFloat.nan
            : max(constraint.height - insets.top - insets.bottom, 0)),
              tree: childTree)
    return Layout(
      component: self,
      size: CGSize(width: childLayout.size.width + insets.left + insets.right,
                   height: childLayout.size.height + insets.top + insets.bottom),
      children: [
        LayoutChild(
          layout: childLayout,
          position: CGPoint(x: insets.left, y: insets.top))
      ])
  }
}
