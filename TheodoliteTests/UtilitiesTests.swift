//
//  UtilitiesTests.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/12/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

class UtilitiesTests: XCTestCase {
  func test_setAssociatedObject_getAssociatedObject() {
    class ObjClass {}
    class ValueClass {}
    
    let obj = ObjClass()
    let val = ValueClass()
    var key: Void? = nil
    
    setAssociatedObject(object: obj, value: val, associativeKey: &key)
    let retrieved: ValueClass? = getAssociatedObject(object: obj, associativeKey: &key)
    
    XCTAssert(retrieved === val)
  }
}
