# `HStack`, `VStack`, and `ZStack`
___
allows us to
- specify an _alignment_
```swift
VStack(alignment: .leading) {}
```
- specify how much space to place between the views
```swift
VStack(spacing: 20) {}
```

use one or more `Spacer` views to push the contents of your stack to one side
```swift
VStack {
    Spacer()
    Text("First")
    Text("Second")
    Text("Third")
    Spacer()
    Spacer()
}
```
`ZStack` doesn’t have the concept of spacing because the views overlap, but it _does_ have alignment
`ZStack` draws its contents from top to bottom, back to front.

# color
___
`background()` modifier, which can be given a color to draw like this
```swift
ZStack {
    Text("Your content")
        .background(.red)
}
```
If you want to fill in red the whole area behind the text
```swift
ZStack {
    Color.red
    Text("Your content")
}
```
In fact, `Color.red` _is_ a view in its own right, which is why it can be used like shapes and text.

use the `frame()` modifier to ask for specific sizes
```swift
Color.red
    .frame(minWidth: 200, maxWidth: .infinity, maxHeight: 200)
```
rgb
```swift
Color(red: 1, green: 0.8, blue: 0)
```

_the safe area_
`.ignoresSafeArea()` modifier to specify which screen edges you want to run up to


```swift
.foregroundStyle(.secondary)
```
```swift
.background(.ultraThinMaterial)
```

# gradients
___
 linear gradient goes in one direction 

```swift
LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottom)
```

```swift
LinearGradient(stops: [
    Gradient.Stop(color: .white, location: 0.45),
    Gradient.Stop(color: .black, location: 0.55),
], startPoint: .top, endPoint: .bottom)
```

as a shortcut we can just write `.init` rather than `Gradient.Stop`
```swift
LinearGradient(stops: [
    .init(color: .white, location: 0.45),
    .init(color: .black, location: 0.55),
], startPoint: .top, endPoint: .bottom)
```

radial gradients move outward in a circle shape
```swift
RadialGradient(colors: [.blue, .black], center: .center, startRadius: 20, endRadius: 200)
```

```swift
AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center)
```


**gradient is created by simply adding `.gradient` after any color**
```swift
Text("Your content")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .foregroundStyle(.white)
    .background(.red.gradient)
```

# buttons and images
___
```swift
Button("Delete selection") {
    print("Now deleting…")
}

Button("Delete selection", action: executeDelete)
```

role
 ```swift
Button("Delete selection", role: .destructive, action: executeDelete)
```

built-in styles for buttons: `.bordered` and `.borderedProminent`
```swift
VStack {
    Button("Button 1") { }
        .buttonStyle(.bordered)
    Button("Button 2", role: .destructive) { }
        .buttonStyle(.bordered)
    Button("Button 3") { }
        .buttonStyle(.borderedProminent)
    Button("Button 4", role: .destructive) { }
        .buttonStyle(.borderedProminent)
}
```

```swift
.buttonStyle(.borderedProminent)
    .tint(.mint)
```

custom label using a second trailing closure
```swift
Button {
    print("Button was tapped")
} label: {
    Text("Tap me!")
        .padding()
        .foregroundStyle(.white)
        .background(.red)
}
```


## images
___
- `Image("pencil")` will load an image called “Pencil” that you have added to your project
- `Image(decorative: "pencil")` will load the same image, but won’t read it out for users who have enabled the screen reader
- `Image(systemName: "pencil")` will load the pencil icon that is built into iOS

```swift
Button("Edit", systemImage: "pencil") {
    print("Edit button was tapped")
}
```

```swift
Image(countries[number])
    .clipShape(.capsule)
    .shadow(radius: 5)
```
# font
___
```swift
.font(.subheadline.weight(.heavy))
```
```swift
.font(.largeTitle.weight(.semibold))
```
![[Pasted image 20231220001151.png]]
# alert messages
___
we create some state that tracks whether our alert is showing
```swift
@State private var showingAlert = false
```
We then attach our alert somewhere to our user interface, telling it to use that state to determine whether the alert is presented or not
SwiftUI will watch `showingAlert`, and as soon as it becomes true it will show the alert.
```swift
struct ContentView: View {
    @State private var showingAlert = false

    var body: some View {
        Button("Show Alert") {
            showingAlert = true
        }
        .alert("Important message", isPresented: $showingAlert) {
            Button("OK") { }
        }
    }
}
```


- $ two-way data binding because SwiftUI will automatically set `showingAlert` back to false when the alert is dismissed
- _any_ button inside an alert will automatically dismiss the alert
-  msg and btn role:
```swift
Button("Show Alert") {
    showingAlert = true
}
.alert("Important message", isPresented: $showingAlert) {
    Button("OK", role: .cancel) { }
} message: {
    Text("Please read this.")
}
```
