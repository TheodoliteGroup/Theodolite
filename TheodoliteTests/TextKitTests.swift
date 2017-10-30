//
//  TextKitTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

class TextKitTests: XCTestCase {
  func test_simpleAttributesEqual() {
    let attr1 = TextKitAttributes(
      attributedString: NSAttributedString(string: "hello"))
    let attr2 = TextKitAttributes(
      attributedString: NSAttributedString(string: "hello"))
    XCTAssertEqual(attr1, attr2)
  }

  func test_simpleAttributesHashesEqual() {
    let attr1 = TextKitAttributes(
      attributedString: NSAttributedString(string: "hello"))
    let attr2 = TextKitAttributes(
      attributedString: NSAttributedString(string: "hello"))
    XCTAssertEqual(attr1.hashValue, attr2.hashValue)
  }
}
