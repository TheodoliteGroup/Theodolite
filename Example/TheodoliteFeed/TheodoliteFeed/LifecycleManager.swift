//
//  LifecycleManager.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/14/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit
import Theodolite

/**
 A caching, immutable lifecycle management system.
 
 You probably don't need to know about this collection of structs, classes, and enums... that is, unless you're working
 on something pretty deep in the framework.
 
 The Lifecycle struct contains immutable tools that manage the process of constructing, sizing, mounting, and unmounting
 component hierarchies. This system is built to be immutable so that it may be processed asynchronously in a
 transactional manner.
 
 The Lifecycle.State enum is mostly what you should interact with. It allows lifecycles to be checkpointed and cached
 for the next execution. This means that asking for a component that has already sized at a particular size is likely
 to hit a cached value without you having to do anything.
 */
struct Lifecycle {
  class Input {
    let factory: (() -> Component)
    weak var listener: StateUpdateListener?
    let previous: ScopeRoot?
    let stateUpdateMap: [Int32: Any?]
    
    init(factory: @escaping () -> Component,
         listener: StateUpdateListener?,
         previous: ScopeRoot?,
         stateUpdateMap: [Int32: Any?]) {
      self.factory = factory
      self.listener = listener
      self.previous = previous
      self.stateUpdateMap = stateUpdateMap
    }
  }
  
  static func construct(_ input: Input) -> Construction {
    return Construction(
      input: input,
      scopeRoot: ScopeRoot(previousRoot: input.previous,
                           listener: input.listener,
                           stateUpdateMap: input.stateUpdateMap,
                           factory: input.factory))
  }
  
  struct Construction {
    let input: Input
    let scopeRoot: ScopeRoot
  }
  
  struct SizeInput {
    let construction: Construction
    let constraint: CGSize
  }
  
  static func size(_ sizeInput: SizeInput) -> Sized {
    return Sized(
      sizeInput: sizeInput,
      layout:
      sizeInput
        .construction
        .scopeRoot
        .root.component()
        .layout(constraint: sizeInput.constraint,
                tree: sizeInput.construction.scopeRoot.root))
  }
  
  struct Sized {
    let sizeInput: SizeInput
    let layout: Layout
  }
  
  struct MountInput {
    let sized: Sized
    let view: UIView
  }
  
  static func mount(_ mountInput: MountInput) -> Mounted {
    mountInput
      .sized
      .layout
      .component
      .mount(parentView: mountInput.view,
             layout: mountInput.sized.layout,
             position: CGPoint(x: 0, y: 0))
    return Mounted(sized: mountInput.sized, view: mountInput.view)
  }
  
  struct Mounted {
    let sized: Sized
    let view: UIView
  }
  
  static func unmount(_ mounted: Mounted) -> Sized {
    mounted
      .sized
      .sizeInput
      .construction
      .scopeRoot
      .traverse({ (c: Component) in
        c.unmount()
      })
    return mounted.sized
  }
  
  enum State {
    case input(Input)
    case construction(Construction)
    case sized(Sized)
    case mounted(Mounted)
    
    func size(constraint: CGSize) -> (State, CGSize) {
      switch self {
      case let .input(input):
        let sized = Lifecycle.size(
          Lifecycle.SizeInput(
            construction: Lifecycle.construct(input),
            constraint: constraint))
        return (State.sized(sized), sized.layout.size)
      case let .construction(construction):
        let sized = Lifecycle.size(
          Lifecycle.SizeInput(
            construction: construction,
            constraint: constraint))
        return (State.sized(sized), sized.layout.size)
      case let .sized(sized):
        if sized.sizeInput.constraint == constraint {
          // We can return the cached size
          return (self, sized.layout.size)
        } else {
          let sized = Lifecycle.size(
            Lifecycle.SizeInput(
              construction: sized.sizeInput.construction,
              constraint: constraint))
          return (State.sized(sized), sized.layout.size)
        }
      case let .mounted(mounted):
        return (self, mounted.sized.layout.size)
      }
    }
    
    func mount(view: UIView, constraint: CGSize) -> State {
      switch self {
      case let .input(input):
        let sized = Lifecycle.size(
          Lifecycle.SizeInput(
            construction: Lifecycle.construct(input),
            constraint: constraint))
        return State.mounted(Lifecycle.mount(Lifecycle.MountInput(sized: sized, view: view)))
      case let .construction(construction):
        // We already have a constructed hierarchy, we need to size and
        let sized = Lifecycle.size(
          Lifecycle.SizeInput(
            construction: construction,
            constraint: constraint))
        return State.mounted(Lifecycle.mount(Lifecycle.MountInput(sized: sized, view: view)))
      case let .sized(sized):
        // If the constraining size is identical, we can simply mount using the cached sized hierarchy. If not, we must
        // re-compute.
        if sized.sizeInput.constraint == constraint {
          return State.mounted(Lifecycle.mount(Lifecycle.MountInput(sized: sized, view: view)))
        } else {
          let sized = Lifecycle.size(
            Lifecycle.SizeInput(
              construction: sized.sizeInput.construction,
              constraint: constraint))
          return State.mounted(Lifecycle.mount(Lifecycle.MountInput(sized: sized, view: view)))
        }
      case let .mounted(mounted):
        if mounted.view !== view {
          // First, we have to un-mount the component hierarchy
          let _ = Lifecycle.unmount(mounted)
          
          // Now we verify we're working under the same size constraints as we were originally built with. If not, then
          // we must re-construct and re-size.
          if mounted.sized.sizeInput.constraint == constraint {
            return State.mounted(Lifecycle.mount(Lifecycle.MountInput(sized: mounted.sized, view: view)))
          } else {
            // We can't use our caches layout. We have to re-compute our sized state, and then use that to mount.
            let sized = Lifecycle.size(
              Lifecycle.SizeInput(
                construction: mounted.sized.sizeInput.construction,
                constraint: constraint))
            return State.mounted(Lifecycle.mount(Lifecycle.MountInput(sized: sized, view: view)))
          }
        }
      }
      assertionFailure("Should not be reached")
      return self
    }
    
    func unmount() -> State {
      switch self {
      case .input:
        assertionFailure("Should have been mounted to unmount")
        return self
      case .construction:
        assertionFailure("Should have been mounted to unmount")
        return self
      case .sized:
        assertionFailure("Should have been mounted to unmount")
        return self
      case let .mounted(mounted):
        return State.sized(Lifecycle.unmount(mounted))
      }
    }
  }
}

final class LifecycleManager: StateUpdateListener {
  let factory: () -> Component
  let constraint: CGSize
  
  var stateUpdateMap: [Int32:Any?]
  var queue: DispatchQueue
  var enqueued: Bool = false
  
  var lifecycle: Lifecycle.State?
  
  init(constraint: CGSize, factory: @escaping () -> Component) {
    self.stateUpdateMap = [:]
    self.factory = factory
    self.constraint = constraint
    self.queue = DispatchQueue(label: "org.theodolite.lifecycleManager")
    self.lifecycle = nil
    
    // Completed init, can now reference self
    self.lifecycle = Lifecycle
      .State
      .input(
        Lifecycle
          .Input(factory: self.factory,
                 listener: self,
                 previous: nil,
                 stateUpdateMap: self.stateUpdateMap))
  }
  
  func size() -> CGSize {
    if let lifecycle = self.lifecycle {
      let (newLifecycle, size) = lifecycle.size(constraint: self.constraint)
      self.lifecycle = newLifecycle
      return size
    }
    assertionFailure("Should have a lifecycle to call size")
    return CGSize(width: 0, height: 0)
  }
  
  // MARK: StateUpdateListener
  
  func receivedStateUpdate(identifier: Int32, update: Any?) {
    assert(Thread.isMainThread)
    self.stateUpdateMap[identifier] = update
    self.enqueueUpdate()
  }
  
  // MARK: Asynchronous Processing
  func enqueueUpdate() {
    assert(Thread.isMainThread)
    if (self.enqueued) {
      return
    }
    self.enqueued = true
    DispatchQueue.main.async {
      // First we dispatch to the main thread to coalesce updates
      let capturedLifecycle = self.lifecycle!
      let stateUpdates = self.stateUpdateMap
      self.queue.async {
        let newState = capturedLifecycle.size(constraint: <#T##CGSize#>)
      }
    }
  }
}
