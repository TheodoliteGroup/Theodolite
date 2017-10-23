//
//  IteratorWrapper.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/23/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

struct IteratorWrapper<T: AnyObject> {
  private var iterator: EnumeratedIterator<IndexingIterator<Array<T>>>
  
  var current: T? = nil
  var offset: Int = 0
  
  init(_ it: EnumeratedIterator<IndexingIterator<Array<T>>>,
       initialOffset: Int = 0) {
    self.iterator = it
    if let next = iterator.next() {
      current = next.element
      offset = next.offset + initialOffset
    }
  }
  
  func find(_ val: T) -> Int? {
    let tempIterator = iterator.makeIterator()
    for (o, v) in tempIterator {
      if v === val {
        return o + offset
      }
    }
    return nil
  }
  
  mutating func advance() {
    if let next = iterator.next() {
      current = next.element
      offset += 1
    } else {
      current = nil
      offset += 0
    }
  }
}
