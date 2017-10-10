//
//  View.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

class Attr<ViewType: UIView, ValueType: AnyObject>: Attribute {
  convenience init(value: ValueType,
                   applicator: @escaping (ViewType) -> (ValueType?) -> ()) {
    self.init();
    self.identifier = "\(applicator)";
    self.value = value;
    self.applicator = applicator as? (UIView) -> (AnyObject?) -> ();
  }
  
  convenience init(value: ValueType,
                   applicator: @escaping (ViewType, ValueType?) -> ()) {
    self.init();
    self.identifier = "\(applicator)";
    self.value = value;
    self.applicator = { (view: UIView) in
      return {(obj: AnyObject?) in
        applicator(view as! ViewType, obj as! ValueType?);
      }
    }
  }
}

class Attribute: Equatable, Hashable {
  internal var identifier: String;
  internal var value: AnyObject?;
  internal var applicator: ((UIView) -> (AnyObject?) -> ())?;
  
  public var hashValue: Int {
    return self.identifier.hashValue;
  }
  
  init() {
    self.identifier = "";
    self.value = nil;
    self.applicator = nil;
  }
  
  func apply(view: UIView) {
    if let applicator = self.applicator,
      let value = self.value {
      applicator(view)(value);
    }
  }
}

func ==(lhs: Attribute, rhs: Attribute) -> Bool {
  return lhs.identifier == rhs.identifier
    && lhs.value === rhs.value;
}

struct ViewConfiguration: Equatable, Hashable {
  let view: UIView.Type;
  let attributes: [Attribute];
  
  public var hashValue: Int {
    return self.attributes.reduce(self.view.hash()) {
      (value: Int, attr: Attribute) -> Int in
      return value ^ attr.hashValue;
    };
  }
  
  func applyToView(v: UIView) {
    assert(type(of: v) == view);
    for attr in self.attributes {
      attr.apply(view: v);
    }
  }
  
  func buildView() -> UIView {
    let v = self.view.init();
    self.applyToView(v: v);
    return v;
  }
}

func ==(lhs: ViewConfiguration, rhs: ViewConfiguration) -> Bool {
  return lhs.view === rhs.view
    && lhs.attributes == rhs.attributes;
}
