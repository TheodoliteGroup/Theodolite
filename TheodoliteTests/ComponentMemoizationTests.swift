//
//  ComponentMemoizationTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 11/1/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

class ComponentMemoizationTests: XCTestCase {
  func test_returningFalse_from_shouldComponentUpdate_doesNotUpdate() {
    final class TestComponent: TypedComponent {
      public let context = ComponentContext()
      typealias PropType = String

      func shouldComponentUpdate(previous: Component) -> Bool {
        return false
      }
    }

    let c1 = TestComponent {"hello"}

    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [:])

    // Force other props here so the default method would cause it to update
    let c2 = TestComponent {"argh"}

    let scope2 = Scope(listener: nil,
                       component: c2,
                       previousScope: scope1,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [:])

    XCTAssert(scope1._component === c1)
    XCTAssert(scope2._component === c1)
  }

  func test_notChangingProps_doesNotUpdate() {
    final class TestComponent: TypedComponent {
      public let context = ComponentContext()
      typealias PropType = String
    }

    let c1 = TestComponent {"hello"}

    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [:])

    let c2 = TestComponent {"hello"}

    let scope2 = Scope(listener: nil,
                       component: c2,
                       previousScope: scope1,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [:])

    XCTAssert(scope1._component === c1)
    XCTAssert(scope2._component === c1)
  }

  func test_changingProps_updates() {
    final class TestComponent: TypedComponent {
      public let context = ComponentContext()
      typealias PropType = String
    }

    let c1 = TestComponent {"hello"}

    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [:])

    let c2 = TestComponent {"argh"}

    let scope2 = Scope(listener: nil,
                       component: c2,
                       previousScope: scope1,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [:])

    XCTAssert(scope1._component === c1)
    XCTAssert(scope2._component === c2)
  }
}
