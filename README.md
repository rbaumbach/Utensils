# Utensils [![Bitrise](https://app.bitrise.io/app/e22e45ed089adf65/status.svg?token=cwKZO_QGnlOMJUS58SBOmg&branch=master)](https://app.bitrise.io/app/e22e45ed089adf65) [![Cocoapod Version](https://img.shields.io/cocoapods/v/Utensils.svg)](https://github.com/rbaumbach/Utensils) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Cocoapod Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](https://github.com/rbaumbach/Capsule) [![License](https://img.shields.io/dub/l/vibe-d.svg)](https://github.com/rbaumbach/InstagramSimpleOAuth/blob/master/MIT-LICENSE.txt)

A set of useful iOS tools.

## Adding Utensils to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add Utensils to your project.

1.  Add Utensils to your Podfile `pod 'Utensils'`.
2.  Install the pod(s) by running `pod install`.
3.  Add Utensils to your files with `import Utensils`.

### Carthage

You can also use [Carthage](https://github.com/Carthage/Carthage) to manually add the Utensils dynamic framework to your project.

1. Add `github "rbaumbach/Utensils"` to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).
2. [Follow instructions to manually add](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) Utensils dynamic framework to your project.

### Clone from Github

1.  Clone repository from github and copy files directly, or add it as a git submodule.
2.  Add all files from `Source` directory to your project.

## What tools?

* A debouncer:

```
let debouncer = Debouncer()

debouncer.mainDebounce(seconds: 0.1) {
    thingy.doExpensiveWork()
}
```

* A directory:

```
let directory = Directory(.temp(additionalPath: "filez/"))
```

And more to come...

## Goodies

All tools will have accompanying protocols and fakes for those of you that enjoy testing your software.  This allows you to program your application to this "interface" and then you can stub it out with your own fake implementation for unit tests.

## Testing

* Prerequisites: [ruby](https://github.com/sstephenson/rbenv), [ruby gems](https://rubygems.org/pages/download), [bundler](http://bundler.io)

This project has been setup to use [fastlane](https://fastlane.tools) to run the specs.

First, bundle required gems and then install Cocoapods when in the project directory:

```bash
$ bundle
$ bundle exec pod install
```

And then use fastlane to run all the specs on the command line:

```bash
$ bundle exec fastlane specs
```

## Suggestions, requests, and feedback

Thanks for checking out Utensils.  Any feedback, suggestions and feedback can be can be sent to: github@ryan.codes, or opened as a github issue.
