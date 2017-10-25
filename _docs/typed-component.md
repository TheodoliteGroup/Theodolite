---
docid: typed-component
title: Typed Component
layout: docs
permalink: /docs/typed-component
---

TypedComponent is the standard protocol that your components should conform to.

It allows you to declare the prop types and state types for your component, and implements most of the core
methods for you in an extension.

Here's what a component would look like:

```swift
final class MyComponent: TypedComponent {
 typealias PropType = String
 // Note that state type is optional
}
```

Then you can construct this component like so:

```swift
MyComponent { "Hello World" }
```

For more advanced usages, please see [Props](/docs/props) and [State](/docs/state).
