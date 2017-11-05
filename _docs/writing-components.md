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

## 1. Subclass Component

Component is the superclass that provides the generic Component API. All components must derive from Component.

## 2. Conform to TypedComponent

TypedComponent on the other hand provides typing for `props` and `state`. It's a protocol with two `associatedTypes`: `PropType` and `StateType`.

## 3. Define your props

Components need input data to do anything interesting. This input is called `props` in the React vocabulary ([read more here](http://theodolite.org/docs/props)). After you define the `PropType` typealias, the values passed to your component are available in render through the `props` property.

## 4. Implement render

The `render()` function is where most of your work is going to be done. Inside `render`, you can read your props, transform the values you find within, read state, and map to child components to render your content.

## Adding state

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

## Updating state

If you want your state value to **change**, then you simply call `self.updateState(yourNewValue)`. This will rebuild the entire component hierarchy, and will re-flow into your `render()` function again, giving you an opportunity to react to the state type.
