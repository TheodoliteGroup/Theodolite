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
}
