//
//  LabelComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/13/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public final class LabelComponent: TypedComponent {
  public struct Options {
    let view: ViewOptions
    
    let font: UIFont
    
    let textColor: UIColor
    
    let shadowColor: UIColor?
    let shadowOffset: CGSize
    
    let textAlignment: NSTextAlignment
    
    let isMultiline: Bool
    
    public init(
      view: ViewOptions = ViewOptions(),
      
      font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize),
      
      textColor: UIColor = UIColor.black,
      
      shadowColor: UIColor? = nil,
      shadowOffset: CGSize = CGSize(width:0, height: -1),
      
      textAlignment: NSTextAlignment = .natural,
      
      isMultiline: Bool = false) {
      
      self.view = view
      
      self.font = font
      
      self.textColor = textColor
      
      self.shadowColor = shadowColor
      self.shadowOffset = shadowOffset
      
      self.textAlignment = textAlignment
      
      self.isMultiline = isMultiline
    }
  }
  
  public typealias PropType = (
    String,
    options: Options
  )
  public typealias ViewType = UILabel
  
  private var cachedView: ViewConfiguration? = nil
  
  public init() {};
  
  func attributes() -> Dictionary<NSAttributedStringKey, Any> {
    var attr: Dictionary<NSAttributedStringKey, Any> = [:]
    attr[NSAttributedStringKey.font] = self.props.options.font
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode =
      self.props.options.isMultiline
      ? NSLineBreakMode.byWordWrapping
      : NSLineBreakMode.byTruncatingTail
    attr[NSAttributedStringKey.paragraphStyle] = paragraphStyle
    return attr
  }
  
  func attributedString() -> NSAttributedString {
    return NSAttributedString.init(string: self.props.0,
                                   attributes: self.attributes())
  }
  
  public func view() -> ViewConfiguration? {
    assert(Thread.isMainThread)
    if let cachedView = self.cachedView {
      return cachedView
    }
    
    let props = self.props
    
    var attributes: [Attribute] = [
      Attr(self.attributedString(), applicator: {
        (label: UILabel, str: NSAttributedString) in
        label.attributedText = str
      })
    ]
    
    attributes.append(Attr(props.options.textColor, identifier: "theodolite-textColor")
    {(label: UILabel, val: UIColor) in
      label.textColor = val
    })
    
    if let shadowColor = props.options.shadowColor {
      attributes.append(Attr(shadowColor, identifier: "theodolite-shadowColor")
      {(label: UILabel, val: UIColor) in
        label.shadowColor = val
      })
      
      attributes.append(Attr(props.options.shadowOffset, identifier: "theodolite-shadowOffset")
      {(label: UILabel, val: CGSize) in
        label.shadowOffset = val
      })
    }
    
    attributes.append(Attr(props.options.textAlignment, identifier: "theodolite-textAlignment")
    {(label: UILabel, val: NSTextAlignment) in
      label.textAlignment = val
    })
    
    attributes.append(Attr(props.options.isMultiline, identifier: "theodolite-isMultiline")
    {(label: UILabel, isMultiline: Bool) in
      label.numberOfLines = isMultiline ? 0 : 1
    })
      
    attributes += self.props.options.view.viewAttributes()
    cachedView = ViewConfiguration(
      view: UILabel.self,
      attributes: attributes)
    return cachedView
  }
  
  public func layout(constraint: CGSize, tree: ComponentTree) -> Layout {
    let size = self.attributedString().boundingRect(
      with: constraint,
      options: [.usesLineFragmentOrigin, .usesFontLeading],
      context: nil)
    return Layout(component: self,
                  size: CGSize(
                    width: ceil(size.width),
                    height: ceil(size.height)),
                  children: [])
  }
}
