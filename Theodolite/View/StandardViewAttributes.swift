//
//  StandardViewAttributes.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/14/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

// MARK: Standard UIView Attributes

/**
 A utility struct that can be exposed as props for a component that renders a view
 to provide simple configuration of most common UIView parameters.
 */
public struct ViewOptions {
  let backgroundColor: UIColor?
  let tintColor: UIColor?
  
  let isMultipleTouchEnabled: Bool?
  let isExclusiveTouchEnabled: Bool?
  
  let clipsToBounds: Bool?
  
  let alpha: CGFloat?
  
  let contentMode: UIViewContentMode?
  
  public init(backgroundColor: UIColor? = nil,
              tintColor: UIColor? = nil,
              isMultipleTouchEnabled: Bool? = nil,
              isExclusiveTouchEnabled: Bool? = nil,
              clipsToBounds: Bool? = nil,
              alpha: CGFloat? = nil,
              contentMode: UIViewContentMode? = nil) {
    self.backgroundColor = backgroundColor
    self.tintColor = tintColor
    self.isMultipleTouchEnabled = isMultipleTouchEnabled
    self.isExclusiveTouchEnabled = isExclusiveTouchEnabled
    self.clipsToBounds = clipsToBounds
    self.alpha = alpha
    self.contentMode = contentMode
  }
  
  public func viewAttributes() -> [Attribute] {
    var attrs: [Attribute] = []
    if let color = self.backgroundColor {
      attrs.append(ViewBackgroundColor(color))
    }
    if let color = self.tintColor {
      attrs.append(ViewTintColor(color))
    }
    if let isMultipleTouchEnabled = self.isMultipleTouchEnabled {
      attrs.append(ViewIsMultipleTouchEnabled(isMultipleTouchEnabled))
    }
    if let isExclusiveTouchEnabled = self.isExclusiveTouchEnabled {
      attrs.append(ViewIsExclusiveTouchEnabled(isExclusiveTouchEnabled))
    }
    if let clipsToBounds = self.clipsToBounds {
      attrs.append(ViewClipsToBounds(clipsToBounds))
    }
    if let alpha = self.alpha {
      attrs.append(ViewAlpha(alpha))
    }
    if let contentMode = self.contentMode {
      attrs.append(ViewContentMode(contentMode))
    }
    return attrs
  }
}

public func ViewBackgroundColor(_ color: UIColor) -> Attribute {
  return Attr<UIView, UIColor>(color, identifier: "theodolite-setBackgroundColor") {(view: UIView, val: UIColor) in
    view.backgroundColor = val;
  }
}

public func ViewTintColor(_ color: UIColor) -> Attribute {
  return Attr<UIView, UIColor>(color, identifier: "theodolite-setTintColor") {(view: UIView, val: UIColor) in
    view.tintColor = val;
  }
}

public func ViewIsMultipleTouchEnabled(_ enabled: Bool) -> Attribute {
  return Attr<UIView, Bool>(enabled, identifier: "theodolite-setIsMultipleTouchEnabled") {(view: UIView, val: Bool) in
    view.isMultipleTouchEnabled = val;
  }
}

public func ViewIsExclusiveTouchEnabled(_ enabled: Bool) -> Attribute {
  return Attr<UIView, Bool>(enabled, identifier: "theodolite-setIsExclusiveTouchEnabled") {(view: UIView, val: Bool) in
    view.isExclusiveTouch = val;
  }
}

public func ViewClipsToBounds(_ enabled: Bool) -> Attribute {
  return Attr<UIView, Bool>(enabled, identifier: "theodolite-setClipsToBounds") {(view: UIView, val: Bool) in
    view.clipsToBounds = val;
  }
}

public func ViewAlpha(_ enabled: CGFloat) -> Attribute {
  return Attr<UIView, CGFloat>(enabled, identifier: "theodolite-setAlpha") {(view: UIView, val: CGFloat) in
    view.alpha = val;
  }
}

public func ViewContentMode(_ enabled: UIViewContentMode) -> Attribute {
  return Attr<UIView, UIViewContentMode>(enabled, identifier: "theodolite-setContentMode") {(view: UIView, val: UIViewContentMode) in
    view.contentMode = val;
  }
}
