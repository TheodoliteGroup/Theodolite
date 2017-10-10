//
//  ViewPool.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

var kViewPoolMapKey: Void?;

struct ViewPoolMap {
  var hashMap: [ViewConfiguration:ViewPool] = [:];
  
  static func getViewPool(view: UIView, config: ViewConfiguration) -> ViewPool {
    let map: ViewPoolMap? =
      getAssociatedObject(
        object: view,
        associativeKey: &kViewPoolMapKey)
    
    var unwrapped = map ?? ViewPoolMap();
    
    if map == nil {
      setAssociatedObject(object: view,
                          value: map,
                          associativeKey: &kViewPoolMapKey);
    }
    
    if let pool = unwrapped.hashMap[config] {
      return pool;
    }
    
    let pool = ViewPool();
    unwrapped.hashMap[config] = pool;
    return pool;
  }
  
  static func reset(view: UIView) {
    if let map: ViewPoolMap =
      getAssociatedObject(
        object: view,
        associativeKey: &kViewPoolMapKey){
      for (_, var pool) in map.hashMap {
        pool.reset();
      }
    }
  }
}

struct ViewPool {
  var views: [UIView] = [];
  var iterator: Array<UIView>.Iterator;
  
  init() {
    self.iterator = views.makeIterator();
  }
  
  mutating func reset() {
    for view in self.iterator {
      if !view.isHidden {
        view.isHidden = true;
      }
    }
    self.iterator = self.views.makeIterator();
  }
  
  mutating func retrieveView(parent: UIView, config: ViewConfiguration) -> UIView? {
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
