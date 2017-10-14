//
//  StandardViewAttributes.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/14/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

// MARK: Standard UIView Attributes

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
