//
//  NewsItemHeaderComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite

final class NewsItemTitleComponent: Component, TypedComponent {
  typealias PropType = (
    String,
    maximumNumberOfLines: Int
  )
  
  override func render() -> [Component] {
    return [
      InsetComponent(
        (insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0),
         component:
          LabelComponent(
            (self.props.0,
             LabelComponent.Options(
              font: UIFont(name: "Georgia", size: 18)!,
              lineBreakMode: NSLineBreakMode.byWordWrapping,
              maximumNumberOfLines: self.props.maximumNumberOfLines))
        )))
    ]
  }
}
