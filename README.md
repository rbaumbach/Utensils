# Utensils [![Bitrise](https://app.bitrise.io/app/e22e45ed089adf65/status.svg?token=cwKZO_QGnlOMJUS58SBOmg&branch=master)](https://app.bitrise.io/app/e22e45ed089adf65) [![Cocoapod Version](https://img.shields.io/cocoapods/v/Utensils.svg)](https://github.com/rbaumbach/Utensils) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Cocoapod Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](https://github.com/rbaumbach/Capsule) [![License](https://img.shields.io/dub/l/vibe-d.svg)](https://github.com/rbaumbach/InstagramSimpleOAuth/blob/master/MIT-LICENSE.txt)

A set of useful iOS tools.

## What tools?

* A debouncer:

```
let debouncer = Debouncer()

debouncer.mainDebounce(seconds: 0.1) {
    thingy.doExpensiveWork()
}
```

And more to come...

## Goodies

All tools will have accompanying protocols and fakes for those of you that enjoy testing your software.  This allows you to program your application to this "interface" and then you can stub it out with your own fake implementation for unit tests
