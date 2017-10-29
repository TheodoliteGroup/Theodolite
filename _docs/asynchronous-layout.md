---
docid: asynchronous-layout
title: Asynchronous Layout
layout: docs
permalink: /docs/asynchronous-layout
---

## Immutability makes multithreading simple

Components are built to be immutable. This makes many of the race conditions and crashes much simpler to deal with in our stack.

This is why it's important that your components remain immutable. Mutable state should be packaged into the `state` type, and through the shared update cycle, state updates are synchronized for multithreaded component updating.

## Components may be constructed on any thread

Most likely, your component will be constructed off the main thread. This means that `render()` and `layout()` will be called off of main. **You must make sure that these methods are pure**.

## Component layouts are memoized

Similar to component memoization, layout trees are also memoized for you using central locking around the layout cache. So don't worry about caching your layouts, they're already cached for you.
