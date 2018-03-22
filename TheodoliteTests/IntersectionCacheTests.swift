//
//  IntersectionCacheTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 3/21/18.
//  Copyright © 2018 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

class IntersectionCacheTestComponent: Component, TypedComponent {
  typealias PropType = String
}

class IntersectionCacheTests: XCTestCase {
  func test_buildingAnEmptyIntersectionCache_doesNotIntersectZero() {
    let component = IntersectionCacheTestComponent("Hello")
    let layout = Layout(component: component,
                        size: CGSize(width:100, height:100),
                        children: [])
    let cache = IntersectionCache(layout: layout)
    XCTAssert(cache.intersectingChildren(rect:CGRect(x: 0, y: 0, width: 0, height: 0)).count == 0)
  }

  func test_buildingAnIntersectionCache_withSingleChild_intersectsWithRectCoveringEntireArea() {
    let component = IntersectionCacheTestComponent("Hello")
    let child = IntersectionCacheTestComponent("Child")
    let layout = Layout(
      component: component,
      size: CGSize(width:100, height:100),
      children: [
        LayoutChild(
          layout:
          Layout(
            component: child,
            size: CGSize(width:50, height:50),
            children:[]),
          position: CGPoint(x: 25, y: 25)
        )
      ])
    let cache = IntersectionCache(layout: layout)
    XCTAssert(cache.intersectingChildren(rect:CGRect(x: 0, y: 0, width: 100, height: 100))[0].layout.component === child)
  }

  func test_buildingAnIntersectionCache_withSingleChild_doesNotIntersectWithRectOutsideParentBounds() {
    let component = IntersectionCacheTestComponent("Hello")
    let child = IntersectionCacheTestComponent("Child")
    let layout = Layout(
      component: component,
      size: CGSize(width:100, height:100),
      children: [
        LayoutChild(
          layout:
          Layout(
            component: child,
            size: CGSize(width:50, height:50),
            children:[]),
          position: CGPoint(x: 25, y: 25)
        )
      ])
    let cache = IntersectionCache(layout: layout)
    XCTAssert(cache.intersectingChildren(rect:CGRect(x: 100, y: 100, width: 100, height: 100)).count == 0)
  }

  func test_buildingAnIntersectionCache_withTwoChildren_intersectsBothWithRectCoveringEntireArea() {
    let component = IntersectionCacheTestComponent("Hello")
    let child1 = IntersectionCacheTestComponent("Child1")
    let child2 = IntersectionCacheTestComponent("Child2")
    let layout = Layout(
      component: component,
      size: CGSize(width:100, height:100),
      children: [
        LayoutChild(
          layout:
          Layout(
            component: child1,
            size: CGSize(width:50, height:50),
            children:[]),
          position: CGPoint(x: 25, y: 25)
        ),
        LayoutChild(
          layout:
          Layout(
            component: child2,
            size: CGSize(width:50, height:50),
            children:[]),
          position: CGPoint(x: 50, y: 50)
        )
      ])
    let cache = IntersectionCache(layout: layout)
    XCTAssert(cache.intersectingChildren(rect:CGRect(x: 0, y: 0, width: 100, height: 100))[0].layout.component === child1)
    XCTAssert(cache.intersectingChildren(rect:CGRect(x: 0, y: 0, width: 100, height: 100))[1].layout.component === child2)
  }

  func test_buildingAnIntersectionCache_withTwoChildren_intersectsOnlyOne_whenRectOnlyIntersectsOne() {
    let component = IntersectionCacheTestComponent("Hello")
    let child1 = IntersectionCacheTestComponent("Child1")
    let child2 = IntersectionCacheTestComponent("Child2")
    let layout = Layout(
      component: component,
      size: CGSize(width:100, height:100),
      children: [
        LayoutChild(
          layout:
          Layout(
            component: child1,
            size: CGSize(width:50, height:50),
            children:[]),
          position: CGPoint(x: 25, y: 25)
        ),
        LayoutChild(
          layout:
          Layout(
            component: child2,
            size: CGSize(width:50, height:50),
            children:[]),
          position: CGPoint(x: 50, y: 50)
        )
      ])
    let cache = IntersectionCache(layout: layout)
    XCTAssert(cache.intersectingChildren(rect:CGRect(x: 80, y: 80, width: 100, height: 100))[0].layout.component === child2)
  }

  func test_buildingAnIntersectionCache_withTwoChildren_intersectsNone_whenRectOutsideArea() {
    let component = IntersectionCacheTestComponent("Hello")
    let child1 = IntersectionCacheTestComponent("Child1")
    let child2 = IntersectionCacheTestComponent("Child2")
    let layout = Layout(
      component: component,
      size: CGSize(width:100, height:100),
      children: [
        LayoutChild(
          layout:
          Layout(
            component: child1,
            size: CGSize(width:50, height:50),
            children:[]),
          position: CGPoint(x: 25, y: 25)
        ),
        LayoutChild(
          layout:
          Layout(
            component: child2,
            size: CGSize(width:50, height:50),
            children:[]),
          position: CGPoint(x: 50, y: 50)
        )
      ])
    let cache = IntersectionCache(layout: layout)
    XCTAssert(cache.intersectingChildren(rect:CGRect(x: -80, y: -80, width: 10, height: 10)).count == 0)
  }

  func test_buildingAnIntersectionCache_withTwoChildren_andZeroSize_intersectsNone_whenRectOutsideArea() {
    let component = IntersectionCacheTestComponent("Hello")
    let child1 = IntersectionCacheTestComponent("Child1")
    let child2 = IntersectionCacheTestComponent("Child2")
    let layout = Layout(
      component: component,
      size: CGSize(width:0, height:0),
      children: [
        LayoutChild(
          layout:
          Layout(
            component: child1,
            size: CGSize(width:50, height:50),
            children:[]),
          position: CGPoint(x: 25, y: 25)
        ),
        LayoutChild(
          layout:
          Layout(
            component: child2,
            size: CGSize(width:50, height:50),
            children:[]),
          position: CGPoint(x: 50, y: 50)
        )
      ])
    let cache = IntersectionCache(layout: layout)
    XCTAssert(cache.intersectingChildren(rect:CGRect(x: -80, y: -80, width: 10, height: 10)).count == 0)
  }

  func test_buildingAnIntersectionCache_withTwoChildren_andZeroSize_intersectsBothWithRectCoveringEntireArea() {
    let component = IntersectionCacheTestComponent("Hello")
    let child1 = IntersectionCacheTestComponent("Child1")
    let child2 = IntersectionCacheTestComponent("Child2")
    let layout = Layout(
      component: component,
      size: CGSize(width:0, height:0),
      children: [
        LayoutChild(
          layout:
          Layout(
            component: child1,
            size: CGSize(width:50, height:50),
            children:[]),
          position: CGPoint(x: 25, y: 25)
        ),
        LayoutChild(
          layout:
          Layout(
            component: child2,
            size: CGSize(width:50, height:50),
            children:[]),
          position: CGPoint(x: 50, y: 50)
        )
      ])
    let cache = IntersectionCache(layout: layout)
    XCTAssert(cache.intersectingChildren(rect:CGRect(x: 0, y: 0, width: 100, height: 100))[0].layout.component === child1)
    XCTAssert(cache.intersectingChildren(rect:CGRect(x: 0, y: 0, width: 100, height: 100))[1].layout.component === child2)
  }
}
