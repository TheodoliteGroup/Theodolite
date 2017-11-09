---
docid: faq
title: FAQ
layout: docs
permalink: /docs/faq
---

## Frequently Asked Questions

### Why should I use Theodolite instead of UIViews?

Well, you probably **shouldn't**. Instead, you should use Theodolite **with** UIViews. Theodolite is great at managing scrolling lists of data, but your views are still just UIViews. You can use Theodolite to asynchronously lay out your existing UIViews to provide fast scrolling list views. This is the same way that Facebook has used ComponentKit in our core apps with great success.

### Why is this different from ComponentKit? Why isn't it part of the same library?

ComponentKit is built in Objective-C++. The C++ part turned out to be horrendously hard to bridge into Swift without killing the expressiveness of ComponentKit, and the performance the framework was built to provide.

Theodolite grew up as my side-project in trying to imagine what ComponentKit would be like if we were to re-build it with all we have learned.

That being said, it's built intentionally to integrate with ComponentKit down the road. The lifecycle is exactly paired with the lifecycle of CKComponents.

### Why not just use React Native?

You probably should use React Native! Theodolite is built for those apps that require full native performance (yes, there is a performance cost of using React Native, but to be honest, the vast majority of apps really shouldn't care about it)

### Why not just use (Render | Katana | Other Swift React clone)

Those frameworks are great. It's basically a point of personal preference. However, Theodolite is built to integrate with the other FB frameworks extremely well, and to mirror the technologies on both our platforms with the same vocabulary.

### Why can't we use pure protocols?

I'm not convinced we can't, and I definitely tried to do that from the start. Ideally Component is just a protocol that TypedComponent conforms with. However, this had the following problems:

1. We want to provide an initializer for you. It reduces the boilerplate. Initializers in protocols are insanely awkward, and autocompletion sucks.
2. The props, state, mounted view, and scope handles must be attached to components. As it turns out the de-facto method of adding these types of data to protocolized objects in Swift extensions is associated objects, and they're really slow compared to property accessors.

So I decided to split the core Component API into a superclass that you subclass, and leave the typed (aka generic) part of the API in the TypedComponent protocol. This is slightly more verbose, but the performance and autocompletion benefits outweigh the problem.
