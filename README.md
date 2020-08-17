# Utensils [![Bitrise](https://app.bitrise.io/app/e22e45ed089adf65/status.svg?token=cwKZO_QGnlOMJUS58SBOmg&branch=master)](https://app.bitrise.io/app/e22e45ed089adf65) [![Cocoapod Version](https://img.shields.io/cocoapods/v/Utensils.svg)](https://github.com/rbaumbach/Utensils) [![Cocoapod Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](https://github.com/rbaumbach/Utensils) [![License](https://img.shields.io/dub/l/vibe-d.svg)](https://github.com/rbaumbach/Utensils/blob/master/MIT-LICENSE.txt)

A set of useful iOS tools.

## Adding Utensils to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add Utensils to your project.

1.  Add Utensils to your Podfile `pod 'Utensils'`.
2.  Install the pod(s) by running `pod install`.
3.  Add Utensils to your files with `import Utensils`.

### Clone from Github

1.  Clone repository from github and copy files directly, or add it as a git submodule.
2.  Add all files from `Source` directory to your project.

## What tools?

* A `Debouncer`:

```
let debouncer = Debouncer()

debouncer.mainDebounce(seconds: 0.1) {
    thingy.doExpensiveWork()
}
```

* A `Directory`:

```
let directory = Directory(.temp(additionalPath: "filez/"))
```

* A persistence tool called `Trunk`:

```
let trunk = Trunk()

trunk.save(data: [0, 1, 2, 3, 4])

let arrayOfInts: [Int]? = trunk.load()
```

* An `AppLaunchViewController`

Using the default launch view:

```
let appLaunchViewController = AppLaunchViewController { print("I'm launching!") }
```

Using a custom user supplied view:

```
let appLaunchViewController = AppLaunchViewController { thingy.doSomethingLengthyBeforeAppLaunches() }
appLaunchViewController.customLoadingView = fancyBrandedLoadingView
```

Note: The custom view will be anchored to all 4 corners of view controller

* A generic `Validator`

```
let email = Email(string: "billy@goat.com")

let isValidEmail = AnyValidator<Email>().isValid(email)
```

And more to come...

## Goodies

All tools will have accompanying protocols and fakes for those of you that enjoy testing your software.  This allows you to program your application to this "interface" and then you can stub it out with your own fake implementation for unit tests.

## Testing

* Prerequisites: [ruby](https://github.com/sstephenson/rbenv), [ruby gems](https://rubygems.org/pages/download), [bundler](http://bundler.io)

This project has been setup to use [fastlane](https://fastlane.tools) to run the specs.

First, bundle required gems, install [Cocoapods](http://cocoapods.org). Next, inside the root project directory run:

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
