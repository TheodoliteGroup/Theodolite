//
//  StateMode.swift
//  Theodolite
//
//  Created by Oliver Rickard on 3/22/18.
//  Copyright © 2018 Oliver Rickard. All rights reserved.
//

import Foundation

/** Used with the updateState() function on components. Determines the way the state update will be handled. */
public enum StateMode {
  /**
   Signifies that the state update may be carried out asynchronously. Asynchronous updates may involve a short delay
   as they process on a background thread. This delay is about as much as you could expect from dispatch_async to a bg
   thread, and then back to main thread, so in most apps will be completely negligible.

   NOTE: This is a hint more than a command. The system may still decide to process your update on the main thread.

   This should be the default mode for almost all state updates because it prevents frame drops during scrolling.
   */
  case async
  /**
   Processes updates synchronously, within the scope of the current call to updateState().

   Useful for 2 cases:

   1. Avoiding the thread-trampoline delay for extremely important updates. The dispatch_asyncs in the async mode above
      can sometimes be an issue if your computation is heavy within your app. For example, if you have a button that
      you want to update colors right after the user presses it, then sync mode is probably what you want.

   2. Interacting with the responder chain/synchronous APIs. Certain APIs, such as Apple's responder chain-based
      keyboard systems require fully synchronous changes to take place in order to work. For example, if text input
      is ongoing, calls to change properties of a text view can disturb autocomplete state if not done within the scope
      of the text view's delegate callbacks.
  */
  case sync
}

