//
//  ViewMountTests.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/12/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
@testable import Theodolite

class ViewMountTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }
  
  func testBlank() {
    let view = UIView();
    view.frame = CGRect(x: 0, y: 0, width: 50, height: 50);
    view.backgroundColor = UIColor.red;
    FBSnapshotVerifyView(view)
  }
}
