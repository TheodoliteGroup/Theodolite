<block class="carthage" />

## Adding Theodolite to your Project with Carthage

For [Carthage](https://github.com/Carthage/Carthage), add the following to your Cartfile:

```
github "TheodoliteGroup/Theodolite" ~> 0.1.0
```

Then run this command in the root of your directory:

```
$ carthage bootstrap
```

This will download Theodolite into the `Carthage/Checkouts` folder of your project.

It's recommended that you drag the Xcodeproj file from the `Carthage/Checkouts/Theodolite` folder into your project, and add the `Theodolite.framework` dependency to your project.

If you'd prefer to directly use the Carthage-generated framework, this also works! You can see a guide on how to do that [here](https://medium.com/compass-true-north/third-party-dependency-management-with-carthage-fc3d713493b6)
