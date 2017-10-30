//
//  ImageComponentSnapshotTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

import FBSnapshotTestCase
@testable import Theodolite

class ImageComponentSnapshotTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = true
  }

  func test_normalRenderingWithColor() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      let image = ImageFrom(color: UIColor.blue, size: CGSize(width: 100, height: 100))
      return ImageComponent {
        (image,
         size: CGSize(width: 100, height: 100),
         options: ViewOptions())
      }
    }
  }
}

func ImageFrom(color: UIColor, size: CGSize) -> UIImage {
  let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
  UIGraphicsBeginImageContext(rect.size)
  let context = UIGraphicsGetCurrentContext()
  context!.setFillColor(color.cgColor)
  context!.fill(rect)
  let img = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  return img!
}
