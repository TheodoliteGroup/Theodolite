---
docid: typed-component
title: Typed Component
layout: docs
permalink: /docs/typed-component
---

TypedComponent is the standard protocol that your components should conform to.

It allows you to declare the prop types and state types for your component, some of the core methods in extensions.

All TypedComponents must be subclasses of Component, which provides the core Component API.

Here's what a component would look like:

```swift
final class MyComponent: Component, TypedComponent {
 typealias PropType = String
 // Note that state type is optional
}
```

Then you can construct this component like so:

```swift
MyComponent { "Hello World" }
```

For more advanced usages, please see [Props](/docs/props) and [State](/docs/state).

## Memoization

TypedComponents are automatically memoized if their prop type conforms with the Equatable protocol. This means that large part of your hierarchy can be reused without any work on your part if you implement Equatable. Not every level in the hierarchy needs to implement this protocol, but it's recommended that you implement Equatable at roughly the same levels as you would traditionall split levels for collection view cells. This will keep updates localized to individual cells, and just reflow the overall layout without having to rebuild all the expensive things in siblings.
