//
//  BackgroundComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 3/29/18.
//  Copyright © 2018 Oliver Rickard. All rights reserved.
//

import Foundation

/**
 Places a component on behind another component so that it serves as a "background".

 See OverlayComponent if you want to place an overlay on top of a component.

 The size of this component is determined by its `component` prop (the foreground). The background component is then
 given this size as its constraint for layout.
 */
public final class BackgroundComponent: Component, TypedComponent {
  public typealias PropType = (
    component: Component,
    background: Component
  )

  public override func render() -> [Component] {
    return [self.props.component, self.props.background]
  }

  public override func layout(constraint: SizeRange, tree: ComponentTree) -> Layout {
    let childTree = tree.children()[0]
    let backgroundTree = tree.children()[1]
    let childLayout = childTree
      .component()
      .layout(
        constraint: constraint,
        tree: childTree)
    let backgroundLayout = backgroundTree
      .component()
      .layout(constraint: SizeRange(childLayout.size),
              tree: backgroundTree)
    return Layout(
      component: self,
      size: constraint.clamp(childLayout.size),
      children: [
        LayoutChild(
          layout: backgroundLayout,
          position: CGPoint.zero),
        LayoutChild(
          layout: childLayout,
          position: CGPoint.zero)
      ])
  }
}
