//
//  ComponentKeyTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

class ComponentKeyTests: XCTestCase {
  func test_providingComponentWithKey_makesThatKeyAvailable() {
    let c = ViewComponent(key: "hello")
    { ViewConfiguration(view: UIView.self, attributes: []) }

    XCTAssertEqual(c.key(), "hello")
  }
}
