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
  
  func reset() {
    for view in views {
      if !view.isHidden {
        view.isHidden = true
      }
    }
  }
  
  func checkoutView(parent: UIView, config: ViewConfiguration) -> UIView? {
    if let view = views.first {
      if view.isHidden {
        view.isHidden = false
      }
      config.applyToView(v: view)
      views.removeFirst()
      return view
    }
    let newView = config.buildView()
    parent.addSubview(newView)
    return newView
  }
  
  func checkinView(view: UIView) {
    views.append(view)
  }
}
