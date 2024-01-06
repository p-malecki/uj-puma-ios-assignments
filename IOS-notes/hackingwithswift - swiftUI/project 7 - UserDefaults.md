
# UserDefaults
___
Common way to store a small amount of data (simple user preferences)

SwiftUI can often wrap up `UserDefaults` inside a nice and simple property wrapper called `@AppStorage` – it only supports a subset of functionality right now, but it can be really helpful.

### saving the data
```swift
@State private var tapCount = 0

...

UserDefaults.standard.set(tapCount, forKey: "Tap")
```

### reading the data back
```swift
@State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
```

# `@AppStorage` property wrapper
___
This works like `@State`: when the value changes, it will reinvoked the `body` property so our UI reflects the new data
```swift
@AppStorage("tapCount") private var tapCount = 0
```
doesn’t make it easy to handle storing complex objects such as Swift structs