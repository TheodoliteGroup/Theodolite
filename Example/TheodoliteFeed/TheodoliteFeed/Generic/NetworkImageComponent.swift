//
//  NetworkImageComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/1/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit
import Theodolite

final class NetworkImageComponent: Component, TypedComponent {
  typealias PropType = (
    URL,
    size: CGSize,
    insets: UIEdgeInsets,
    backgroundColor: UIColor,
    contentMode: UIViewContentMode
  )
  typealias StateType = UIImage

  func scaledImage(image:UIImage, size: CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    defer { UIGraphicsEndImageContext() }
    image.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
    return UIGraphicsGetImageFromCurrentImageContext()!
  }

  func resizedImage(image:UIImage, size:CGSize) -> UIImage {
    let aspect = image.size.width / image.size.height
    if size.width / aspect <= size.height {
      return scaledImage(image:image, size:CGSize(width: size.width, height: size.width / aspect))
    } else {
      return scaledImage(image:image, size:CGSize(width: size.height * aspect, height: size.height))
    }
  }

  override func render() -> [Component] {
    // Don't capture self here
    let props = self.props
    let state = self.state
    return [
      NetworkDataComponent(
        (props.0,
         { [weak self] (networkState: NetworkDataComponent.State) -> Component? in
          var component: Component? = nil
          switch networkState {
          case .pending:
            component = SizeComponent(
              (size: SizeRange(props.size),
               component: ViewComponent(
                ViewConfiguration(
                  view: UIView.self,
                  attributes:
                  ViewOptions(backgroundColor: props.backgroundColor)
                    .viewAttributes())
              ))
            )
            break
          case .data(let data):
            guard let image = state ?? UIImage(data: data) else {
              break
            }
            let resized = self!.resizedImage(image:image, size:props.size)
            if state == nil {
              self!.updateState(state: resized)
            }
            component = ImageComponent(
              ({ resized },
               size: props.size,
               options: ViewOptions(
                clipsToBounds: true,
                contentMode: props.contentMode))
            )
            break
          case .error:
            break
          }

          if let component = component {
            return InsetComponent(
              (insets: props.insets,
               component:component))
          }
          return nil
        })
      )
    ]
  }
}
