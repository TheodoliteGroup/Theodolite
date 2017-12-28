//
//  NewsItemCardComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/4/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite
import SafariServices

final class NewsItemCardComponent: Component, TypedComponent {
  typealias PropType = (
    NewsItem,
    navigationCoordinator: NavigationCoordinator
  )

  override func render() -> [Component] {
    let props = self.props

    let topComponent: Component
    if let imageURL = props.0.media.imageURL {
      topComponent = NewsItemFeaturedImageComponent( imageURL )
    } else {
      topComponent = ViewComponent( ViewConfiguration(view: UIView.self, attributes: []) )
    }

    return [
      InsetComponent(
        (insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
        component:
        ViewCompositeComponent(
          (ViewConfiguration(
            view: UIView.self,
            attributes:
            ViewOptions(
              layerOptions:
              LayerOptions(
                cornerRadius: 8,
                shadowColor: UIColor.black,
                shadowOpacity: 0.3,
                shadowOffset: CGSize(width: 0, height: 2),
                shadowRadius: 5)).viewAttributes()),
           ViewCompositeComponent(
            (ViewConfiguration(
              view: UIView.self,
              attributes:
              ViewOptions(
                backgroundColor: UIColor.white,
                clipsToBounds: true,
                layerOptions:
                LayerOptions(
                  cornerRadius: 10)).viewAttributes()),
             TapComponent(
              (action: Handler(self, NewsItemCardComponent.tappedItem),
               component:
                FlexboxComponent(
                  (options: FlexOptions(flexDirection: .column),
                   children: [
                    FlexChild(topComponent,
                              flexGrow: 1),
                    FlexChild(NewsItemTitleComponent( ( props.0.title, maximumNumberOfLines: 2 ) ),
                              margin: Edges(left: 20, right: 20, top: 10, bottom: 5))
                    ])
              ))
            ))
          ))
      )))
    ]
  }

  func tappedItem(gesture: UITapGestureRecognizer) {
    let safariVC = SFSafariViewController(url: self.props.0.url)
    self.props.navigationCoordinator.presentViewController(viewController: safariVC)
  }
}
