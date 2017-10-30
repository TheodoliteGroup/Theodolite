//
//  TextComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/29/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public final class TextComponent: TypedComponent {
  public typealias PropType = TextKitAttributes
  public typealias ViewType = TextKitView
  
  public init() {}
  
  public func layout(constraint: CGSize, tree: ComponentTree) -> Layout {
    let renderer = TextKitRenderer.renderer(attributes: self.props,
                                            constrainedSize: constraint)
    return Layout(component: self,
                  size: CGSize(
                    width: ceil(renderer.size.width),
                    height: ceil(renderer.size.height)),
                  children: [])
  }
  
  public func view() -> ViewConfiguration? {
    return ViewConfiguration(
      view: TextKitView.self,
      attributes: [
        Attr(self.props, identifier: "theodolite-TextKitAttributes")
        {(view: TextKitView, attributes: TextKitAttributes) in
          view.attributes = attributes
        }
      ])
  }
}
