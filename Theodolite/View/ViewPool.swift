//
//  ViewPool.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

/**
 Internal view pool. Holds a list of views that Theodolite has constructed, and is responsible for keeping track
 of which views are vended out of its list, and is responsible for hiding any views that haven't been vended in
 any particular mount cycle.
 */
public class ViewPool {
  var views: [UIView] = []
  var index: Int = -1
  
  func reset() {
    for i in index + 1 ..< views.count {
      let view = views[i]
      if !view.isHidden {
        view.isHidden = true
      }
    }
    index = -1
  }
  
  private func next() -> UIView? {
    if (index + 1 < views.count) {
      index += 1
      return views[index]
    }
    return nil
  }
  
  func retrieveView(parent: UIView, config: ViewConfiguration) -> UIView? {
    if let view = self.next() {
      if view.isHidden {
        view.isHidden = false
      }
      config.applyToView(v: view)
      return view
    }
    let newView = config.buildView()
    views.insert(newView, at: index + 1)
    // Advance the index to account for the offset at the beginning
    index += 1
    parent.addSubview(newView)
    return newView
  }
}
