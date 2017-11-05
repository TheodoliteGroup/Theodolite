---
docid: props
title: Props
layout: docs
permalink: /docs/props
---

Theodolite uses a unidirectional data flow with immutable inputs. Following the name established by [React](https://facebook.github.io/react/) and continued in [ComponentKit](http://componentkit.org) and [Litho](http://fblitho.com), the inputs that a `Component` takes are known as *props*.

## Defining and using Props

Props are the inputs to a `Component`'s constructor, and are accessible to that component throughout its life. You define your prop type by conforming with the `TypedComponent` protocol, and defining the `PropType` `typealias` like so:

Take the following `Component`, for example:

```swift
final class MyComponent: Component, TypedComponent {
  typealias PropType = String

  override func render() -> [Component] {
    ... do something with self.props()
  }
}
```

`MyComponent` defines a single string as its props. Parent components that construct a `MyComponent` instance will provide this value to the constructor, and it will be available to your component throughout its lifecycle by calling `self.props()`.

## Multiple inputs: Tuples

You may define a tuple as your `PropType` to receive multiple values as inputs to your component:

```swift
final class MyComponent: Component, TypedComponent {
  typealias PropType = (
    string: String,
    int: Int
  )

  override func render() -> [Component] {
    ... do something with self.props().string or self.props().int
  }
}
```

In this case, the caller must provide both the string and the integer value, and then you can use either in your lifecycle methods.

## Multiple inputs: Struct

You can also use a named value-type for your props:

```swift
final class MyComponent: Component, TypedComponent {
  public struct Props {
    let string: String,
    let int: Int
  }

  typealias PropType = Props

  override func render() -> [Component] {
    ... do something with self.props().string or self.props().int
  }
}
```

This is particularly useful when you want to provide **defaults** for optional values.

## Providing Props

When building a component, we have to provide it the props it expects. Using the first example above, you would construct this component like so:

```swift
MyComponent {"Hello World!"}
```

Note that you're actually providing a lambda that evaluates to the `PropType` here. We do this to provide some syntactical sugar and reduce the number of `()` in callsites, which can get bewildering with sufficiently deep hierarchies.

Here's how you would initialize a component that takes a tuple as its props:

```swift
MyComponent {(
  string: "Hello World!",
  int: 42
)}
```

And a struct as props:

```swift
MyComponent { MyComponent.Props(
  string: "Hello World!",
  int: 42
)}
```

## Optional values in an Options struct

For sufficiently complex prop types, it's recommended that you put **required parameters** at the top-level in a props tuple, and then gather all optional values into an Options struct, and provide default values in its `init()` method for anything that can have simple defaults.

For example, here's a simple `LabelComponent`:

```swift
final class LabelComponent: Component, TypedComponent {
  public struct Options {
    let font: UIFont

    init(font: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize)) {
      self.font = font
    }
  }

  typealias PropType = (
    string: String, // You can omit the name for a single required parameter if you want
    options: Options
  )

  ... lifecycle methods
}
```

Then I can use this component like so:

```swift
LabelComponent {(
  string: "Hello World",
  options: LabelComponent.Options(font: UIFont.systemFontOfSize(42))
)}
```

Or, if I just want to use the defaults, I can do this instead:

```swift
LabelComponent {(
  string: "Hello World",
  options: LabelComponent.Options()
)}
```

## Immutability

The props of a Component are read-only. The Component's parent passes down values for the props when it creates the Component and they cannot change throughout the lifecycle of the Component. If the props values must be updated, the parent has to create a new Component and pass down new values for the props.

The props objects should be made immutable. Due to [background layout](/docs/asynchronous-layout), props may be accessed on multiple threads. Props immutability ensures that no thread safety issues enter into your component hierarchy.
