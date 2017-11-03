//
//  NewsItemFeaturedComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/1/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite
import SafariServices

final class NewsItemFeaturedComponent: TypedComponent {
  let context = ComponentContext()
  typealias PropType = (
    NewsItem,
    navigationCoordinator: NavigationCoordinator
  )

  func render() -> [Component] {
    let props = self.props
    if props.0.imageURL == nil || props.0.description == nil {
      return [
        NewsItemComponent { props }
      ]
    }

    return [
      InsetComponent {(
        insets: UIEdgeInsets(top: 10, left: 0, bottom: 40, right: 0),
        component:
        TapComponent {
          (action: Handler(self, NewsItemFeaturedComponent.tappedItem),
           component:
            FlexboxComponent {
              (options: FlexOptions(flexDirection: .column),
               children: [
                FlexChild(NewsItemHeaderComponent { props.0.author },
                          margin: Edges(left: 20, right: 20, top: 0, bottom: 0)),
                FlexChild(NewsItemFeaturedTitleComponent { props.0.title },
                          margin: Edges(left: 20, right: 20, top: 0, bottom: 0)),
                FlexChild(NewsItemFeaturedImageComponent { props.0.imageURL! }),
                FlexChild(NewsItemDescriptionComponent { props.0.description! },
                          margin: Edges(left: 20, right: 20, top: 10, bottom: 0))
                ])
          })
      })
      }
    ]
  }

  func tappedItem(gesture: UITapGestureRecognizer) {
    let safariVC = SFSafariViewController(url: self.props.0.url)
    self.props.navigationCoordinator.presentViewController(viewController: safariVC)
  }
}
