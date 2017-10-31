//
//  NewsItemComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite

final class NewsItemComponent: TypedComponent {
  typealias PropType = NewsItem

  func render() -> [Component] {
    var children: [FlexChild] = []
    let props = self.props
    children.append(FlexChild(NewsItemHeaderComponent {
      (imageURL: props.imageURL,
       outletName: props.author)
    }))
    children.append(FlexChild(NewsItemTitleComponent { props.title }))
    if let description = props.description {
      children.append(FlexChild(NewsItemDescriptionComponent { description }))
    }
    return [
      InsetComponent {(
        insets: UIEdgeInsetsMake(10, 20, 40, 20),
        component:
        FlexboxComponent {
          (options: FlexOptions(flexDirection: .column),
           children: children)
        }
        )}
    ]
  }
}
