//
//  NewsItemFeaturedTitleComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/1/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite

final class NewsItemFeaturedTitleComponent: Component, TypedComponent {
  typealias PropType = String

  override func render() -> [Component] {
    return [
      InsetComponent((
        insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0),
        component:
        LabelComponent(
          (self.props,
           LabelComponent.Options(
            font: UIFont(name: "Georgia", size: 24)!,
            lineBreakMode: NSLineBreakMode.byWordWrapping,
            maximumNumberOfLines: 0))
      )))]
  }
}
