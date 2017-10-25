---
docid: intro
title: What is Theodolite?
layout: docs
permalink: /docs/intro
---

Theodolite is a declarative framework for building efficient user interfaces (UI) on iOS. It allows you to write highly-optimized Android views through a simple functional API based on Swift protocols. It was [primarily built](/docs/uses) to implement complex scrollable UIs based on UICollectionView.

With Theodolite, you build your UI in terms of *components* instead of interacting directly with traditional UIKit views. A *component* is essentially a function that takes immutable inputs, called *props*, and returns a component hierarchy describing your user interface.

```swift
final class HelloComponent: TypedComponent {
  typealias PropType = String

  func render() -> [Component] {
    return LabelComponent {
      ("Hello \(self.props())", 
        LabelComponent.Options())
    }
  }
}
```

You simply declare what you want to display and Theodolite takes care of rendering it in the most efficient way by computing [layout in a background thread](/docs/asynchronous-layout), automatically [flattening your view hierarchy](/docs/view-flattening), and [automatically reusing views](/docs/recycling) in complex component hierarchies.

## Part of the Family

Theodolite is built to be nearly identical to Facebook's Litho and ComponentKit native React frameworks.

## Continue exploring

Have a look at our [Tutorial](/docs/tutorial) for a step-by-step guide on using Theodolite in your app. You can also read the quick start guide on how to [write](/docs/writing-components) and [use](/docs/using-components) your own Theodolite components.
