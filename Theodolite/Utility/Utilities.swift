//
//  Utilities.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

func setAssociatedObject<T>(object: AnyObject, value: T, associativeKey: UnsafeRawPointer) {
  objc_setAssociatedObject(object,
                           associativeKey,
                           value,
                           objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

func getAssociatedObject<T>(object: AnyObject, associativeKey: UnsafeRawPointer) -> T? {
  if let v = objc_getAssociatedObject(object, associativeKey) as? T {
    return v
  }
  
  return nil
}

/* Since apple deprecated OSAtomic methods, we use this little container instead. */
struct Atomic<T> {
  var val: T
  var queue: DispatchQueue
  
  init(_ val: T) {
    self.val = val
    self.queue = DispatchQueue(label: "com.components.atomic")
  }
  
  mutating func update(_ updater: (T) -> T) -> T {
    var newVal: T? = nil
    queue.sync {
      newVal = updater(self.val)
      self.val = newVal!
    }
    return newVal!
  }
}
