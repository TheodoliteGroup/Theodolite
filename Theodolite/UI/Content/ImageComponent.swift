//
//  ImageComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public final class ImageComponent: TypedComponent {
  public typealias PropType = (
    UIImage,
    options: ViewOptions
  )

  public init() {}

  public func view() -> ViewConfiguration? {
    var attributes = self.props.options.viewAttributes()

    attributes.append(Attr(self.props.0, identifier: "theodolite-TextKitAttributes")
    {(view: UIImageView, image: UIImage) in
      view.image = image})

    return ViewConfiguration(
      view: UIImageView.self,
      attributes: attributes
    )
  }
}
