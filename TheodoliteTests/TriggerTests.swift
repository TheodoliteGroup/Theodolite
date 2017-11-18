//
//  TriggerTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 11/18/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

class TriggerTests: XCTestCase {
  class TestObject {
    let action: () -> ()

    func actionMethod() {
      self.action()
    }

    init(action: @escaping () -> ()) {
      self.action = action
    }
  }

  class TestStringObject {
    let action: (String) -> ()

    func actionMethod(str: String) {
      self.action(str)
    }

    init(action: @escaping (String) -> ()) {
      self.action = action
    }
  }

  func test_thatDefaultTriggers_doNotCrash() {
    let trigger: Trigger<Int32> = Trigger<Int32>()
    trigger.invoke(0)
  }

  func test_whenUsingSimpleTrigger_resolvedFunctionIsCalled() {
    var calledFunction = false
    let testObj = TestObject(action: {
      calledFunction = true
    })
    let trigger = Trigger<Void>()
    let handler = Handler(testObj, TestObject.actionMethod)
    trigger.resolve(handler)
    trigger.invoke()
    XCTAssert(calledFunction)
  }

  func test_whenProvidingStringArgumentToTrigger_resolvedHandlerReceivesString() {
    var obj: String? = nil
    let testObj = TestStringObject(action: { (str: String) in
      obj = str
    })
    let str = "hello"
    let trigger = Trigger<String>()
    let handler = Handler(testObj, TestStringObject.actionMethod)
    trigger.resolve(handler)
    trigger.invoke(str)
    XCTAssert(obj == str)
  }
}
