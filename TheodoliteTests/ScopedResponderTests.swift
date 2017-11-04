//
//  ScopedResponderTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 11/4/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

class ScopedResponderTests: XCTestCase {
  func test_creatingEmptyResponderList_returnsNilForResponder() {
    let list = ResponderList()
    XCTAssert(list.getResponder(0) == nil)
  }

  func test_addingObject_thenGettingResponder_returnsSameObject() {
    class TestObject {}
    let list = ResponderList()
    let obj = TestObject()
    let index = list.append(obj)
    XCTAssertEqual(index, 0)
    XCTAssert(list.getResponder(index) === obj)
  }

  func test_creatingScopedResponder_withObject_returnsThatObjectAsResponder() {
    class TestObject {}
    let list = ResponderList()
    let obj = TestObject()
    let responder = ScopedResponder(list: list, responder: obj)
    XCTAssert(responder.responder() === obj)
  }

  func test_twoScopedResponders_withSameList_andDifferentObjects_returnsCorrectResponderForEach() {
    class TestObject {}
    let list = ResponderList()
    let obj1 = TestObject()
    let responder1 = ScopedResponder(list: list, responder: obj1)

    let obj2 = TestObject()
    let responder2 = ScopedResponder(list: list, responder: obj2)

    XCTAssert(responder1.responder() === obj1)
    XCTAssert(responder2.responder() === obj2)
  }
}
