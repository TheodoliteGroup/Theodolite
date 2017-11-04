//
//  NewsItemContentComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/31/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite

final class NewsItemContentComponent: Component, TypedComponent {
  typealias PropType = (
    imageURL: URL?,
    description: String?
  )

  override func render() -> [Component] {
    var children: [FlexChild] = []

    if let imageURL = props.imageURL {
      children.append(
        FlexChild(
          NewsItemImageComponent { imageURL }))
    }

    if let description = props.description {
      children.append(
        FlexChild(
          NewsItemDescriptionComponent { description },
          flexShrink: 1))
    }

    if children.count == 0 {
      return []
    }

    return [
      FlexboxComponent {
        (options: FlexOptions(flexDirection: .row,
                              alignItems: .center),
         children: children)
      }
    ]
  }
}
