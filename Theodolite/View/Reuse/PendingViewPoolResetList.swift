//
//  PendingViewPoolResetList.swift
//  Theodolite
//
//  Created by Oliver Rickard on 4/13/19.
//  Copyright © 2019 Oliver Rickard. All rights reserved.
//

import Foundation

class PendingViewPoolResetList {
  private var pendingViewPools: Set<ViewPool> = Set()
  
  func add(_ pool: ViewPool) {
    pendingViewPools.insert(pool)
  }
  
  func reset() {
    for pool in pendingViewPools {
      pool.reset()
    }
  }
  
  static private let kResetListKey = "theodolite-view-pool-reset-list"
  
  static func getResetList() -> PendingViewPoolResetList {
    let threadDictionary = Thread.current.threadDictionary
    if let cachedObject = threadDictionary[kResetListKey] as? PendingViewPoolResetList {
      return cachedObject
    } else {
      let newList: PendingViewPoolResetList = PendingViewPoolResetList()
      threadDictionary[kResetListKey] = newList
      return newList
    }
  }
  
  static func reset() {
    let threadDictionary = Thread.current.threadDictionary
    if let cachedObject = threadDictionary[kResetListKey] as? PendingViewPoolResetList {
      cachedObject.reset()
      threadDictionary.removeObject(forKey: kResetListKey)
    }
  }
}
