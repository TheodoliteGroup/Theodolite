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
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TheodoliteTodo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TheodoliteTodo

end
```


