---
docid: writing-components
title: Writing Components
layout: docs
permalink: /docs/writing-components
---

```swift
final class FooComponent: Component, TypedComponent {
  typealias PropType = (
    String,
    baz: Int
  )
  override func render() -> [Component] {
    return [BatComponent {
      (title: props.0,
       count: props.baz)
    }]
  }
}
```

## Subclass Component

Component is the superclass that provides the generic Component API. All components must derive from Component.

## Conform to TypedComponent

TypedComponent on the other hand provides typing for `props` and `state`. It's a protocol with two `associatedTypes`: `PropType` and `StateType`.

## Implement `render`

The `render()` function is where most of your work is going to be done. Inside `render`, you can read your props, transform the values you find within, read state, and map to child components to render your content.

## Adding `state`

By default, `StateType` is defined as `Void?`. If you want to add state to your component, you just add another typealias to your component:

```swift
final class FooComponent: Component, TypedComponent {
  typealias PropType = String
  typealias StateType = Int
  override func render() -> [Component] {
    return [BatComponent {
      (title: props.0,
       count: state)
    }]
  }
  override func initialState() -> Int? {
    return 0
  }
}
```
