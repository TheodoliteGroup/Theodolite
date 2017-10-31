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

final class NewsItemHeaderComponent: TypedComponent {
  typealias PropType = (
    imageURL: URL?,
    outletName: String?
  )
  typealias StateType = UIImage

  func render() -> [Component] {
    var children: [FlexChild] = []
    if let imageURL = props.imageURL {
      children.append(
        FlexChild(
          NewsItemImageComponent { imageURL }))
    }
    if let outletName = props.outletName {
      children.append(
        FlexChild(
          LabelComponent {
            (outletName,
             LabelComponent.Options(
              font: UIFont.systemFont(ofSize: 12),
              textColor: UIColor.lightGray,
              lineBreakMode: NSLineBreakMode.byWordWrapping,
              maximumNumberOfLines: 0))
          },
          margin:
          Edges(left: 0,
                right: 20,
                top: 0,
                bottom: 0)))
    }

    return [
      InsetComponent {
        (insets: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0),
         component:
          FlexboxComponent {
            (options: FlexOptions(flexDirection: .row,
                                  alignItems: .center),
             children: children)
          }
        )}
    ]
  }
}
