//
//  ViewPool.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public class ViewPool {
  var views: [UIView] = [];
  var iterator: Array<UIView>.Iterator;
  
  init() {
    self.iterator = views.makeIterator();
  }
  
  func reset() {
    for view in self.iterator {
      if !view.isHidden {
        view.isHidden = true;
      }
    }
    self.iterator = self.views.makeIterator();
  }
  
  func retrieveView(parent: UIView, config: ViewConfiguration) -> UIView? {
    if let view = self.iterator.next() {
      if view.isHidden {
        view.isHidden = false;
      }
      config.applyToView(v: view);
      return view;
    }
    let newView = config.buildView();
    self.views.append(newView);
    parent.addSubview(newView);
    return newView;
  }
}
