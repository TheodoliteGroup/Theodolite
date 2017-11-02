//
//  NetworkSource.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

enum NetworkSourceResult<ItemType> {
  case error(string: String)
  case success([ItemType])
}

protocol NetworkSource {
  associatedtype ItemType

  func fetchItems(_ received: @escaping (NetworkSourceResult<ItemType>) -> ())
}
