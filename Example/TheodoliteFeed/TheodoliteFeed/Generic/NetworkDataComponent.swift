//
//  NetworkDataComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/1/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit
import Theodolite

final class NetworkDataComponent: Component, TypedComponent {
  enum DataError: Error {
    case error(String)
  }

  enum State {
    case data(Data)
    case pending
    case error(Error)
  }

  private var fetched: Bool = false

  typealias PropType = (
    URL,
    (State) -> Component?
  )
  typealias StateType = State

  override func render() -> [Component] {
    self.fetchDataIfNeeded()
    let state = self.state ?? State.pending
    if let component = props.1(state) {
      return [component]
    }
    return []
  }

  override func componentWillMount() {
    super.componentWillMount()
  }

  static let session = URLSession(configuration: URLSessionConfiguration.default)

  func fetchDataIfNeeded() {
    if state == nil && !fetched {
      fetched = true
      self.updateState(state: State.pending)

      let request = URLRequest(url: self.props.0)
      let task: URLSessionDataTask = NetworkDataComponent.session.dataTask(with: request)
      { (data, response, error) -> Void in
        if let data = data {
          self.updateState(state: State.data(data))
        } else if let error = error {
          self.updateState(state: State.error(error))
        } else {
          self.updateState(state: State.error(DataError.error("Could not load data")))
        }
      }
      task.resume()
    }
  }
}
