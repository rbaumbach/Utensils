# Utensils [![Cocoapod Version](https://img.shields.io/cocoapods/v/Utensils.svg)](https://github.com/rbaumbach/Utensils) [![SPM Compatible](https://img.shields.io/badge/SPM-Compatible-blue)](https://swift.org/package-manager/) [![Cocoapod Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](https://github.com/rbaumbach/Utensils) [![License](https://img.shields.io/dub/l/vibe-d.svg)](https://github.com/rbaumbach/Utensils/blob/master/MIT-LICENSE.txt)

A set of useful iOS tools.

## Adding Utensils to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add Utensils to your project.

1.  Add Utensils to your Podfile `pod 'Utensils'`.
2.  Install the pod(s) by running `pod install`.
3.  Add Utensils to your files with `import Utensils`.

### Swift Package manager

[Swift Package Manager](https://swift.org/package-manager/) can be used to add `Utensils` the to your project:

1.  Add `.package(url: "https://github.com/rbaumbach/Utensils", from: "0.2.2")`
2.  [Follow intructions to add](https://swift.org/getting-started/#using-the-package-manager) the Utensils package to your project.

### Clone from Github

1.  Clone repository from github and copy files directly, or add it as a git submodule.
2.  Add all files from `Source` directory to your project.

## What tools?

* A `Debouncer`:

```Swift
let debouncer = Debouncer()

debouncer.mainDebounce(seconds: 0.1) {
    thingy.doExpensiveWork()
}
```

* A `Directory`:

```Swift
let directory = Directory(.temp(additionalPath: "filez/"))
```

* A persistence tool called `Trunk`:

```Swift
let trunk = Trunk()

trunk.save(data: [0, 1, 2, 3, 4])

let arrayOfInts: [Int]? = trunk.load()
```

* An `AppLaunchViewController`

Using the default launch view:

```Swift
let appLaunchViewController = AppLaunchViewController { print("I'm launching!") }
```

Using a custom user supplied view:

```Swift
let appLaunchViewController = AppLaunchViewController { thingy.doSomethingLengthyBeforeAppLaunches() }
appLaunchViewController.customLoadingView = fancyBrandedLoadingView
```

Note: The custom view will be anchored to all 4 corners of view controller

* A generic `Validator`

```Swift
let email = Email(string: "billy@goat.com")

let isValidEmail = AnyValidator<Email>().isValid(email)
```

* A json `FileLoader`

```Swift
do {
    let decodedJSON: Model? = try FileLoader().loadJSON(name: "file", fileExtension: "json")
} catch {
    // handle error
}
```

* A "pequeno" networker

```swift
let networker = PequenoNetworking(baseURL: "https://dogsrbettahthancats.party")

// Ol' skool Any json response

networker.request(httpMethod: .get,
                  endpoint: "/dogs",
                  headers: ["version": "v1"],
                  parameters: ["breed": "chihuahua"],
                  completionHandler: { result in print(result) }
                  
networker.requestAndDeserialize(httpMethod: .get,
                                endpoint: "/dogs",
                                headers: ["version": "v1"],
                                parameters: ["breed": "chihuahua"]) { 
                                (result: Result<[Dog], PequenoNetworking.Error>) in
    print(result))
}
```

Note: Currently only supports `GET` requests.

Note: The `Model` must conform to `Codable`

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
