//
//  ScopedResponder.swift
//  Theodolite
//
//  Created by Oliver Rickard on 11/4/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

/**
 Components are constantly being re-generated in response to state updates. This means that if
 an action 
 */
internal class ResponderList {
  private let lock: os_unfair_lock_t = {
    let lock = os_unfair_lock_t.allocate(capacity: 1)
    lock.initialize(to: os_unfair_lock_s(), count: 1)
    return lock
  }()
  private var responders: NSPointerArray = NSPointerArray.weakObjects()

  deinit {
    lock.deinitialize(count: 1)
    lock.deallocate(capacity: 1)
  }

  internal func append(_ object: AnyObject) -> Int {
    os_unfair_lock_lock(lock); defer { os_unfair_lock_unlock(lock) }
    let index = responders.count
    responders.addPointer(Unmanaged.passUnretained(object).toOpaque())
    return index
  }

  internal func getResponder(_ index: Int) -> AnyObject? {
    if index >= responders.count {
      return nil
    }

    var candidate: AnyObject? = object(at: index)
    var currentIndex = index
    while currentIndex + 1 < responders.count && candidate == nil {
      currentIndex += 1
      candidate = object(at: currentIndex)
    }
    return candidate
  }

  private func object(at index: Int) -> AnyObject? {
    if let ptr = responders.pointer(at: index) {
      return Unmanaged<AnyObject>.fromOpaque(ptr).takeUnretainedValue()
    } else {
      return nil
    }
  }
}

internal class ScopedResponder {
  internal let responderList: ResponderList
  private let captureIndex: Int

  init(list: ResponderList, responder: AnyObject) {
    self.captureIndex = list.append(responder)
    self.responderList = list
  }

  init() {
    self.captureIndex = 0
    self.responderList = ResponderList()
  }

  func responder() -> AnyObject? {
    return self.responderList.getResponder(self.captureIndex)
  }
}
