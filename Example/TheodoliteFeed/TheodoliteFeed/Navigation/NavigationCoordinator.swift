//
//  NavigationCoordinator.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/3/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

class NavigationCoordinator {
 weak var navigationController: UINavigationController? = nil

  public func pushViewController(viewController: UIViewController) {
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  public func popViewController() {
    self.navigationController?.popViewController(animated: true)
  }

  public func presentViewController(viewController: UIViewController) {
    self.navigationController?.present(viewController, animated: true, completion: nil)
  }

  public func dismissViewController() {
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
}
