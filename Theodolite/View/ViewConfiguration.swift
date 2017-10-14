//
//  View.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public struct ViewConfiguration: Equatable, Hashable {
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

public func ==(lhs: ViewConfiguration, rhs: ViewConfiguration) -> Bool {
  return lhs.view === rhs.view
    && lhs.attributes == rhs.attributes;
}
