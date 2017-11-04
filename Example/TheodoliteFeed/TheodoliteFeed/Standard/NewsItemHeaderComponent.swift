//
//  NewsItemHeaderComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/31/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

import Flexbox
import Theodolite

final class NewsItemHeaderComponent: Component, TypedComponent {
  typealias PropType = String?

  override func render() -> [Component] {
    guard let props = props else {
      return []
    }
    return [
      InsetComponent {
        (insets: UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0),
         component:
          LabelComponent {
            (props,
             LabelComponent.Options(
              font: UIFont.systemFont(ofSize: 12),
              textColor: UIColor.lightGray,
              lineBreakMode: NSLineBreakMode.byWordWrapping,
              maximumNumberOfLines: 0))
          }
        )}
    ]
  }
}
