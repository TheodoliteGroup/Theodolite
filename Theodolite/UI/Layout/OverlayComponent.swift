//
//  OverlayComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 3/28/18.
//  Copyright © 2018 Oliver Rickard. All rights reserved.
//

import Foundation

/**
 Overlays a component on top of another component.

 See BackgroundComponent if you want to place a background behind another component.

 The size of this component is determined by its `component` prop. The overlay component is then given this size as its
 constraint for layout.
 */
public final class OverlayComponent: Component, TypedComponent {
  public typealias PropType = (
    component: Component,
    overlay: Component
  )

  public override func render() -> [Component] {
    return [self.props.component, self.props.overlay]
  }

  public override func layout(constraint: SizeRange, tree: ComponentTree) -> Layout {
    let childTree = tree.children()[0]
    let overlayTree = tree.children()[1]
    let childLayout = childTree
      .component()
      .layout(
        constraint: constraint,
        tree: childTree)
    let overlayLayout = overlayTree
      .component()
      .layout(constraint: SizeRange(childLayout.size),
              tree: overlayTree)
    return Layout(
      component: self,
      size: constraint.clamp(childLayout.size),
      children: [
        LayoutChild(
          layout: childLayout,
          position: CGPoint.zero),
        LayoutChild(
          layout: overlayLayout,
          position: CGPoint.zero)
      ])
  }
}
