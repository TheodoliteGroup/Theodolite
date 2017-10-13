//
//  ViewPoolMap.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

var kViewPoolMapKey: Void?;

class ViewPoolMap {
  var hashMap: [ViewConfiguration:ViewPool] = [:];
  
  static func getViewPool(view: UIView, config: ViewConfiguration) -> ViewPool {
    let map: ViewPoolMap? =
      getAssociatedObject(
        object: view,
        associativeKey: &kViewPoolMapKey)
    
    let unwrapped = map ?? ViewPoolMap();
    
    if map == nil {
      setAssociatedObject(object: view,
                          value: unwrapped,
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
      for (_, pool) in map.hashMap {
        pool.reset();
      }
    }
  }
}
