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
    let view = UIView()
    let config = ViewConfiguration(view: UILabel.self, attributes: [])
    let map = ViewPoolMap.getViewPoolMap(view: view)
    
    let pool = map.getViewPool(view: view, config: config)
    let pool2 = map.getViewPool(view: view, config: config)
    
    XCTAssert(pool === pool2)
  }
  
  func test_resetOnViewPoolMap_callsResetOnAllPools() {
    let view = UIView()
    let config = ViewConfiguration(view: UILabel.self, attributes: [])
    let map = ViewPoolMap.getViewPoolMap(view: view)
    let component = ViewComponent {config}
    
    let retrieved = map.checkoutView(component: component, parent: view, config: config)
    
    map.checkinView(component: component, parent: view, config: config, view: retrieved!)
    map.reset(view: view)
    
    XCTAssert(retrieved!.isHidden)
  }
  
  func test_reorderViews_thatWereFirstVendedInADifferentOrder() {
    let view = UIView()
    let labelConfig = ViewConfiguration(view: UILabel.self, attributes: [])
    let buttonConfig = ViewConfiguration(view: UIButton.self, attributes: [])
    let map = ViewPoolMap.getViewPoolMap(view: view)
    let labelComponent = ViewComponent {labelConfig}
    let buttonComponent = ViewComponent {buttonConfig}
    
    let retrievedLabel = map.checkoutView(component: labelComponent, parent: view, config: labelConfig)!
    
    let retrievedButton = map.checkoutView(component: buttonComponent, parent: view, config: buttonConfig)!
    
    // OK, so now we should have the 2 views, and retrieved2 should be above retrieved
    XCTAssert(view.subviews.index(of: retrievedLabel)! < view.subviews.index(of: retrievedButton)!)
    
    map.checkinView(component: labelComponent, parent: view, config: labelConfig, view: retrievedLabel)
    map.checkinView(component: buttonComponent, parent: view, config: buttonConfig, view: retrievedButton)
    map.reset(view: view)
    
    // Now, we grab them in the opposite order.
    
    let buttonAgain = map.checkoutView(component: buttonComponent, parent: view, config: buttonConfig)!
    
    let labelAgain = map.checkoutView(component: labelComponent, parent: view, config: labelConfig)!
    
    // Re-ordering subviews occurs on reset
    map.reset(view: view)
    
    // The views should now be swapped in their order so that retrieved should be above retrieved2
    XCTAssert(view.subviews.index(of: buttonAgain)! < view.subviews.index(of: labelAgain)!)
  }
}
