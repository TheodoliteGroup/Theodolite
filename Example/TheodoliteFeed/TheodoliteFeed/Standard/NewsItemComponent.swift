//
//  NewsItemComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite
import SafariServices

final class NewsItemComponent: Component, TypedComponent {
  typealias PropType = (
    NewsItem,
    navigationCoordinator: NavigationCoordinator
  )

  override func render() -> [Component] {
    let props = self.props
    return [
      InsetComponent {(
        insets: UIEdgeInsetsMake(10, 20, 40, 20),
        component:
        TapComponent {
          (action: Handler(self, NewsItemComponent.tappedItem),
           component:
            FlexboxComponent {
              (options: FlexOptions(flexDirection: .column),
               children: [
                FlexChild(NewsItemHeaderComponent { props.0.author }),
                FlexChild(NewsItemTitleComponent { ( props.0.title, maximumNumberOfLines: 0) }),
                FlexChild(NewsItemContentComponent {(
                  imageURL: props.0.imageURL,
                  description: props.0.description
                  )})
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
