//
//  NetworkDataComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/1/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit
import Theodolite

final class NetworkDataComponent: TypedComponent {
  enum DataError: Error {
    case error(String)
  }

  enum State {
    case data(Data)
    case pending
    case error(Error)
  }

  typealias PropType = (
    URL,
    (State) -> Component?
  )
  typealias StateType = State

  func render() -> [Component] {
    if self.state == nil {
      self.updateState(state: State.pending)
      DispatchQueue.global().async {
        do {
          // This is inefficient, but this is a demo app and I don't want to take any deps, so we're just gonna block
          let data = try Data(contentsOf: self.props.0)
          self.updateState(state: State.data(data))
        } catch {
          self.updateState(state: State.error(DataError.error("Failed to load data")))
        }
      }
    }

    let state = self.state ?? State.pending
    if let component = props.1(state) {
      return [component]
    }
    return []
  }
}
