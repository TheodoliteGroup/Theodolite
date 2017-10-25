# Theodolite: A Fast React Framework for Swift

Theodolite allows you to write Components just like React:

```
final class FooComponent: TypedComponent {
  typealias PropType = Int

  func view() -> ViewConfiguration? {
    return LabelComponent {
      ("\(self.props())", LabelComponent.Options())
    }
  }
}
```

```
FooComponent { 42 }
```
