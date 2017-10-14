//
//  RootViewController.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/13/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {


  override func viewDidLoad() {
    super.viewDidLoad()

    let viewController: DataViewController = DataViewController()

    self.addChildViewController(viewController)
    self.view.addSubview(viewController.view)
  }

}

