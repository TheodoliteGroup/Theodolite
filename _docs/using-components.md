---
docid: using-components
title: Using Components
layout: docs
permalink: /docs/using-components
---

# Rendering a Component in a UIView hierarchy

```swift
let view = ComponentHostingView { () -> Component in
  return LabelComponent {
    ("hello",
     LabelComponent.Options())
  }
}
view.frame = self.bounds
view.sizeToFit()
```

`ComponentHostingView` is a `UIView` that you can treat just like a normal view in your hierarchy, and it will act just as you would expect a view to behave. You can call `sizeThatFits:`, `sizetoFit`, `layoutSubviews`, and change its frame. It will process component updates asynchronously, and will re-size itself in response to these updates.

# Creating a new Component

```swift
FooComponent(key: "key") {
  "Some props"
}
```

## TypedComponent provides you with init

When you conform with the TypedComponent protocol, you get a default initializer through an extension. This initializer takes two parameters:

```swift
init(key: AnyHashable? = nil,
     _ props: () -> PropType)
```

### Key

From one generation to the next, Theodolite needs to identify each component so it can be matched up with its prior `state`, and track any state udpates. By default, Theodolite uses the component class as the first identifier, however if more than a single sibling shares the same class, you **must** provide a key to uniquely identify each sibling from one another. This is enforced through an assertion.

The key is any hashable object, and it should be stable between component generations. Each time you change the key value, you disallow matching up prior states with the new generation.

### Props

The prop argument is actually a closure type. This is done purely for syntactical nicety to avoid too many parentheses.
