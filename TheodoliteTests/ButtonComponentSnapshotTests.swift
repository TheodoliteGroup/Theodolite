//
//  ButtonComponentSnapshotTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 12/29/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
import Flexbox
@testable import Theodolite

class ButtonComponentSnapshotTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = true
  }
  
  func test_simpleButton() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return ButtonComponent(ButtonComponent.Options(titles: [.normal: "Hello World"],
                                                     attributes: ViewOptions(backgroundColor: .red).viewAttributes()))
    }
  }
  
  func test_buttonWithDifferentTitleColor() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return ButtonComponent(ButtonComponent.Options(titles: [.normal: "Hello World"],
                                                     titleColors: [.normal: .blue],
                                                     attributes: ViewOptions(backgroundColor: .red).viewAttributes()))
    }
  }
  
  func test_buttonWithDifferentTitleFont() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return ButtonComponent(ButtonComponent.Options(titles: [.normal: "Hello"],
                                                     titleFont: UIFont(name: "Georgia", size: 24),
                                                     attributes: ViewOptions(backgroundColor: .red).viewAttributes()))
    }
  }
  
  func test_buttonWithContentEdgeInsets() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return ButtonComponent(ButtonComponent.Options(titles: [.normal: "Hello"],
                                                     contentEdgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
                                                     attributes: ViewOptions(backgroundColor: .red).viewAttributes()))
    }
  }
  
  func test_buttonWithImage() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return ButtonComponent(ButtonComponent.Options(images: [.normal: ImageFrom(color: .blue, size: CGSize(width: 50, height: 50))],
                                                     attributes: ViewOptions(backgroundColor: .red).viewAttributes()))
    }
  }
  
  func test_buttonWithBackgroundImage() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return ButtonComponent(ButtonComponent.Options(backgroundImages: [.normal: ImageFrom(color: .blue, size: CGSize(width: 50, height: 50))],
                                                     attributes: ViewOptions(backgroundColor: .red).viewAttributes()))
    }
  }
}
