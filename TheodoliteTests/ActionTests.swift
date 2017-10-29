//
//  ActionTests.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/10/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

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

class ActionTests: XCTestCase {
  func test_thatDefaultActions_doNotCrash() {
    let action: Action<Int32> = Action<Int32>()
    action.send(0)
  }
  
  func test_whenUsingSimpleHandlers_functionIsCalled() {
    var calledFunction = false
    let testObj = TestObject(action: {
      calledFunction = true
    })
    let handler = Handler(testObj, TestObject.actionMethod)
    handler.send()
    XCTAssert(calledFunction)
  }
  
  func test_whenProvidingStringArgumentToAction_handlerReceivesString() {
    var obj: String? = nil
    let testObj = TestStringObject(action: { (str: String) in
      obj = str
    })
    let str = "hello"
    let handler = Handler(testObj, TestStringObject.actionMethod)
    handler.send(str)
    XCTAssert(obj == str)
  }
}
