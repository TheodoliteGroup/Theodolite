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

  func test_textKitRendererKeys_equal() {
    let key1 = TextKitRendererKey(
      attributes: TextKitAttributes(
        attributedString: NSAttributedString(string: "hello")),
      constrainedSize: CGSize(width: 5.000005 + 49485, height: 10))
    let key2 = TextKitRendererKey(
      attributes: TextKitAttributes(
        attributedString: NSAttributedString(string: "hello")),
      constrainedSize: CGSize(width: 5.000005 + 49485, height: 10))
    XCTAssertEqual(key1, key2)
  }

  func test_textKitRendererKeys_hashesEqual() {
    let key1 = TextKitRendererKey(
      attributes: TextKitAttributes(
        attributedString: NSAttributedString(string: "hello")),
      constrainedSize: CGSize(width: 5.000005 + 49485, height: 10))
    let key2 = TextKitRendererKey(
      attributes: TextKitAttributes(
        attributedString: NSAttributedString(string: "hello")),
      constrainedSize: CGSize(width: 5.000005 + 49485, height: 10))
    XCTAssertEqual(key1.hashValue, key2.hashValue)
  }

  func test_textKitRendererCache_storesThenRetrieves() {
    let attributes = TextKitAttributes(
      attributedString: NSAttributedString(string: "hello"))
    let renderer1 = TextKitRenderer.renderer(attributes: attributes, constrainedSize: CGSize(width: 100, height: 100))
    let renderer2 = TextKitRenderer.renderer(attributes: attributes, constrainedSize: CGSize(width: 100, height: 100))
    XCTAssert(renderer1 === renderer2)
  }
}
