//
//  TextComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/29/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public final class TextComponent: TypedComponent {
  public typealias PropType = (
    TextKitAttributes,
    options: Options
  )
  public typealias ViewType = TextKitView
  
  public struct Options {
    let view: ViewOptions
    init(view: ViewOptions = ViewOptions()) {
      self.view = view
    }
  }
  
  public init() {}
  
  public func layout(constraint: SizeRange, tree: ComponentTree) -> Layout {
    let renderer = TextKitRenderer.renderer(attributes: self.props.0,
                                            constrainedSize: constraint.max)
    return Layout(component: self,
                  size: constraint.clamp(
                    CGSize(
                      width: ceil(renderer.size.width),
                      height: ceil(renderer.size.height))),
                  children: [])
  }
  
  public func view() -> ViewConfiguration? {
    var attributes = self.props.options.view.viewAttributes()
    
    attributes.append(Attr(self.props.0, identifier: "theodolite-TextKitAttributes")
    {(view: TextKitView, attributes: TextKitAttributes) in
      view.attributes = attributes})
    
    return ViewConfiguration(
      view: TextKitView.self,
      attributes: attributes)
  }
}
