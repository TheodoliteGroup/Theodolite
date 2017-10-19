//
//  LabelComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/13/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public struct LabelProps {
  let string: String
  let font: UIFont?
  let color: UIColor?
}

public final class LabelComponent: TypedComponent {
  public typealias PropType = (
    string: String,
    font: UIFont?,
    color: UIColor?
  )
  
  public init() {};
  
  func attributes() -> Dictionary<String, Any> {
    var attr: Dictionary<String, Any> = [:]
    if let font = self.props().font {
      attr[NSFontAttributeName] = font
    }
    if let color = self.props().color {
      attr[NSForegroundColorAttributeName] = color
    }
    return attr
  }
  
  func attributedString() -> NSAttributedString {
    return NSAttributedString.init(string: self.props().string,
                                   attributes: self.attributes())
  }
  
  public func view() -> ViewConfiguration? {
    return ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr(self.attributedString(), applicator: {
          (label: UILabel, str: NSAttributedString) in
          label.attributedText = str
        }),
        Attr(0, identifier: "numberOfLines") { (label: UILabel, val: Int) in
          label.numberOfLines = 0
        }
      ])
  }
  
  public func size(constraint: CGSize) -> CGSize {
    let size = self.attributedString().boundingRect(
      with: constraint,
      options: .usesLineFragmentOrigin,
      context: nil)
    return CGSize(width: ceil(size.width),
                  height: ceil(size.height))
  }
}
