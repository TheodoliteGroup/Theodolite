//
//  ViewPoolMap.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

var kViewPoolMapKey: Void?

public class ViewPoolMap {
  var hashMap: [ViewConfiguration:ViewPool] = [:]
  var vendedViews: [UIView] = []
  
  static func resetViewPoolMap(view: UIView) {
    // No need to create one if it doesn't already exist
    if let map: ViewPoolMap? =
      getAssociatedObject(
        object: view,
        associativeKey: &kViewPoolMapKey) {
      map?.reset(view: view)
    }
  }
  
  static func getViewPoolMap(view: UIView) -> ViewPoolMap {
    let map: ViewPoolMap? =
      getAssociatedObject(
        object: view,
        associativeKey: &kViewPoolMapKey)
    
    let unwrapped = map ?? ViewPoolMap()
    
    if map == nil {
      setAssociatedObject(object: view,
                          value: unwrapped,
                          associativeKey: &kViewPoolMapKey)
    }
    return unwrapped
  }
  
  func retrieveView(parent: UIView, config: ViewConfiguration) -> UIView? {
    guard let view = getViewPool(view: parent, config: config)
      .retrieveView(parent: parent, config: config) else {
        return nil
    }
    vendedViews.append(view)
    return view
  }
  
  func getViewPool(view: UIView, config: ViewConfiguration) -> ViewPool {
    if let pool = hashMap[config] {
      return pool
    }
    
    let pool = ViewPool()
    hashMap[config] = pool
    return pool
  }
  
  func reset(view: UIView) {
    for (_, pool) in hashMap {
      pool.reset()
    }
    
    // This algorithm is a clone of the one in ViewPoolMap in ComponentKit
    
    var subviews = view.subviews
    var nextVendedViewIt = IteratorWrapper(vendedViews.enumerated().makeIterator())
    
    for i in 0 ..< subviews.count {
      let subview = subviews[i]
      
      // We use linear search here. We could create a std::unordered_set of vended views, but given the typical size of
      // the list of vended views, I guessed a linear search would probably be faster considering constant factors.
      guard let vendedViewIndex = nextVendedViewIt.find(subview) else {
        // Ignore subviews not created by components infra, or that were not vended during this pass (they are hidden).
        continue
      }
      
      if vendedViewIndex != nextVendedViewIt.offset {
        guard let swapIndex = subviews.index(of: nextVendedViewIt.current!) else {
          assertionFailure("Expected to find subview \(subview) in \(view)")
          continue
        }
        
        // This naive algorithm does not do the minimal number of swaps. But it's simple, and swaps should be relatively
        // rare in any case, so let's go with it.
        subviews.swapAt(i, swapIndex)
        view.exchangeSubview(at: i, withSubviewAt: swapIndex)
      }
      
      nextVendedViewIt.advance()
    }
    
    vendedViews.removeAll()
  }
}
