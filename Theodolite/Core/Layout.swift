//
//  Layout.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public struct LayoutChild {
  let layout: Layout;
  let position: CGPoint;
}

public struct Layout {
  let component: Component;
  let size: CGSize;
  let children: [LayoutChild];
  
  /* 
   Can be used to pass data from layout to mount. Useful if you want to pre-compute something, and then use the
   result.
   
   Canonical example is rendering text. You may want to pass the text artifacts from layout to mount so you don't have
   to do the work of laying out the text again when mounting as an optimization.
   
   The framework will always leave this value nil. You can fill it with whatever you want.
  */
  let extra: Any?
  
  init(component: Component,
       size: CGSize,
       children: [LayoutChild],
       extra: Any? = nil) {
    self.component = component;
    self.size = size;
    self.children = children;
    self.extra = extra;
  }
}
