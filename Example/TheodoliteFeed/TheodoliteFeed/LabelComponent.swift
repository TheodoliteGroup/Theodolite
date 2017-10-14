//
//  LabelComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/13/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Theodolite

final class LabelComponent: TypedComponent {
  typealias PropType = (
    string: String,
    font: UIFont?,
    color: UIColor?
  )
  
  func attributes() -> Dictionary<String, Any> {
    var attr: Dictionary<String, Any> = [:];
    if let font = self.props().font {
      attr[NSFontAttributeName] = font;
    }
    if let color = self.props().color {
      attr[NSForegroundColorAttributeName] = color;
    }
    return attr;
  }
  
  func attributedString() -> NSAttributedString {
    return NSAttributedString.init(string: self.props().string,
                                   attributes: self.attributes());
  }
  
  func view() -> ViewConfiguration? {
    return ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr(value: self.attributedString(), applicator: {(label: UILabel, str: NSAttributedString) in
          label.attributedText = str;
          label.font = UIFont.systemFont(ofSize: 12);
        })
      ]);
  }
  
  func size(constraint: CGSize) -> CGSize {
    let size = self.attributedString().boundingRect(
      with: constraint,
      options: NSStringDrawingOptions(),
      context: nil);
    return CGSize(width: ceil(size.width),
                  height: ceil(size.height));
  }
}
