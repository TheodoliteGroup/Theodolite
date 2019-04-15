//
//  NewsItemFeaturedImageComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/1/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

import UIKit
import Theodolite

final class NewsItemFeaturedImageComponent: Component, TypedComponent {
  typealias PropType = URL?
  typealias StateType = UIImage

  override func render() -> [Component] {
    let bounds = UIScreen.main.bounds
    guard let url = props else {
      return []
    }
    return [
      NetworkImageComponent(
        (url,
         size: CGSize(width: bounds.size.width, height: bounds.size.width * 3.0 / 5.0),
         insets: UIEdgeInsets.zero,
         backgroundColor: UIColor(white: 0.95, alpha: 1),
         contentMode: .scaleAspectFill)
      )
    ]
  }
}
