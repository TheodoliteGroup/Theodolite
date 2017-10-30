//
//  ComponentViewController.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

public final class ComponentViewController: UIViewController {
  private let factory: () -> Component

  public init(factory: @escaping () -> Component) {
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func loadView() {
    let hostingView = ComponentHostingView(factory: factory)
    hostingView.backgroundColor = .white

    self.view = hostingView
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
  }
}
