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
    let props = self.props
    return [
      InsetComponent {(
        insets: UIEdgeInsetsMake(10, 20, 40, 20),
        component:
        FlexboxComponent {
          (options: FlexOptions(flexDirection: .column),
           children: [
            FlexChild(NewsItemHeaderComponent { props.author }),
            FlexChild(NewsItemTitleComponent { props.title }),
            FlexChild(NewsItemContentComponent {(
              imageURL: props.imageURL,
              description: props.description
              )})
            ])
        }
        )}
    ]
  }
}
