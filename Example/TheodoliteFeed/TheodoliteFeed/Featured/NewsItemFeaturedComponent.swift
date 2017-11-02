//
//  NewsItemFeaturedComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/1/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite

final class NewsItemFeaturedComponent: TypedComponent {
  let context = ComponentContext()
  typealias PropType = NewsItem

  func render() -> [Component] {
    let props = self.props
    if props.imageURL == nil || props.description == nil {
      return [
        NewsItemComponent { props }
      ]
    }

    return [
      InsetComponent {(
        insets: UIEdgeInsets(top: 10, left: 0, bottom: 40, right: 0),
        component:
        TapComponent {
          (action: Action<UITapGestureRecognizer>(),
           component:
            FlexboxComponent {
              (options: FlexOptions(flexDirection: .column),
               children: [
                FlexChild(NewsItemHeaderComponent { props.author },
                          margin: Edges(left: 20, right: 20, top: 0, bottom: 0)),
                FlexChild(NewsItemFeaturedTitleComponent { props.title },
                          margin: Edges(left: 20, right: 20, top: 0, bottom: 0)),
                FlexChild(NewsItemFeaturedImageComponent { props.imageURL! }),
                FlexChild(NewsItemDescriptionComponent { props.description! },
                          margin: Edges(left: 20, right: 20, top: 10, bottom: 0))
                ])
          })
      })
      }
    ]
  }
}
