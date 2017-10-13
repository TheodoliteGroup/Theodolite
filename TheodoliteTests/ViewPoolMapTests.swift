//
//  ViewPoolMapTests.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

class ViewPoolMapTests: XCTestCase {
  func test_getViewPool_twice_returnsSameViewPool() {
    let view = UIView();
    let config = ViewConfiguration(view: UILabel.self, attributes: []);
    
    let pool = ViewPoolMap.getViewPool(view: view, config: config);
    let pool2 = ViewPoolMap.getViewPool(view: view, config: config);
    
    XCTAssert(pool === pool2);
  }
  
  func test_resetOnViewPoolMap_callsResetOnAllPools() {
    let view = UIView();
    let config = ViewConfiguration(view: UILabel.self, attributes: []);
    
    let pool = ViewPoolMap.getViewPool(view: view, config: config);
    
    let retrieved = pool.retrieveView(parent: view, config: config);
    
    // Reset twice, since the view was vended for the first reset, it is not hidden.
    // On the second reset, the view should be hidden.
    ViewPoolMap.reset(view: view);
    ViewPoolMap.reset(view: view);
    
    XCTAssert(retrieved!.isHidden);
  }
}
