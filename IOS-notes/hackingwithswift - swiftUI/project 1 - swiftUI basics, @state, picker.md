## ContentView
___
struct called `ContentView`, saying that it conforms to the `View` protocol. `View` comes from SwiftUI, and is the basic protocol that must be adopted by anything you want to draw on the screen
```swift
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}
```

```swift
Text("Tap the flag of")
    .foregroundStyle(.white)
```

## form
___
```swift
Form {
    Section {
        Text("Hello, world!")
    }

    Section {
        Text("Hello, world!")
        Text("Hello, world!")
    }
}
```

## navigation bar
___
```swift
NavigationStack {
    Form {
        Section {
            Text("Hello, world!")
        }
    }
    .navigationTitle("SwiftUI")
}
```

```swift
.navigationBarTitleDisplayMode(.inline)
```

## @ state
___
`@State` allows us to work around the limitation of structs: we know we can’t change their properties because structs are fixed, but `@State` allows that value to be stored separately by SwiftUI in a place that _can_ be modified.

```swift
struct ContentView: View {
    @State private var tapCount = 0

    var body: some View {
        Button("Tap Count: \(tapCount)") {
            self.tapCount += 1
        }
    }
}
```
best practice: @State private var tapCount = 0

## binding state to ui controls
___
```swift
struct ContentView: View {
    @State private var name = ""

    var body: some View {
        Form {
            TextField("Enter your name", text: $name)
            Text("Hello, world!")
        }
    }
}
```

## ForEach
___
```swift
ForEach(0 ..< 100) {
        Text("Row \($0)")
    }
```

## Picker view
___
Pickers, like text fields, need a two-way binding to a property so they can track their value.
```swift
Picker("Number of people", selection: $numberOfPeople) {
    ForEach(2 ..< 100) {
        Text("\($0) people")
    }
}
.pickerStyle(.navigationLink)
```
## reading input
___
```swift
TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
    .keyboardType(.decimalPad)
```

`.numberPad` and `.decimalPad`
### hiding keyboard
___
property wrapper: `@FocusState`

Add this new property to `ContentView`:
```swift
@FocusState private var amountIsFocused: Bool
```

`toolbar()` modifier lets us specify toolbar items for a view. These toolbar items might appear in various places on the screen – in the navigation bar at the top, in a special toolbar area at the bottom, and so on.

