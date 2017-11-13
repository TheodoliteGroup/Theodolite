---
docid: tutorial
title: Tutorial
layout: docs
permalink: /docs/tutorial
---

## Let's build a Todo list

### Set up the project

First things first, let's create our Xcode Project. Open Xcode, and navigate to File -> New Project

![File -> New Project](http://theodolite.org/static/images/tutorial/create-single-view-app.png)

Select "Single View App" from the menu.

![Give it a name](http://theodolite.org/static/images/tutorial/create-proj-name.png)

Xcode will create a project for you:

![Fresh Project](http://theodolite.org/static/images/tutorial/fresh-project.png)

### Configuring the Cocoapods dependency

Navigate to the folder that Xcode created for you in the terminal, and initialize cocoapods:

```
$ pod init
```

This will create a Podfile for you, which is where you specify your dependencies:

```
target 'TheodoliteTodo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TheodoliteTodo

end
```

Add the Theodolite pod as a dependency right below where the template says `Pods for TheodoliteTodo`.

```
pod 'Theodolite'
```

Now go back to the terminal, and install the pods:

```
$ pod install
```

![Cocoapods install](http://theodolite.org/static/images/tutorial/pod-install.png)

Cocoapods created an Xcworkspace file for us in the same directory as our Xcodeproj. Close the Xcodeproj in Xcode, and open the new workspace.

### Render a Component

Opening the newly-created workspace, we can see that Cocoapods has added some new dependencies:

![Cocoapods workspace](http://theodolite.org/static/images/tutorial/generated-project.png)

Now, let's import Theodolite, and add the `ComponentHostingView` as a subview of the ViewController that Xcode created for us. `ComponentHostingView` is a `UIView` that can display a Theodoolite Component hierarchy.

First, we have to add the import statement for Theodolite:

```swift
import Theodolite
```

Also, add a hosting view as a property of the view controller:

```swift
class ViewController: UIViewController {
  private var hostingView: ComponentHostingView?
```

Next, let's add the following code to `viewDidLoad`:

```swift
hostingView = ComponentHostingView { () -> Component in
  return LabelComponent {
    ("Hello World",
     LabelComponent.Options())
  }
}
self.view.addSubview(hostingView!)
```

And finally, we need to configure the layout of the hosting view:

```swift
override func viewDidLayoutSubviews() {
  super.viewDidLayoutSubviews()
  hostingView?.frame = UIEdgeInsetsInsetRect(self.view.bounds, self.view.layoutMargins)
}
```

Now your view controller should look like this:

![View controller that renders Hello World](http://theodolite.org/static/images/tutorial/hello-world.png)

Hit Cmd+R to run the project in the simulator, and you should see your hello world!

![Simulator rendering Hello World](http://theodolite.org/static/images/tutorial/sim-hello-world.png)
