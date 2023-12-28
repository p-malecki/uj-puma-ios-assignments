# animation basics
## `animation()` modifier for views
```swift
struct ContentView: View {
    @State private var animationAmount = 1.0 // <- variable to watch changes

    var body: some View {
        Button("Tap Me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .scaleEffect(animationAmount)
        .animation(.easeInOut(duration: 2), value: animationAmount)
    }
}
```
### change size smoothly 
```swift
.scaleEffect(animationAmount)
.animation(.default, value: animationAmount) // this line add smoothness
```

### type of animation modifiers
```swift
.animation(.linear, value: animationAmount)
.animation(.spring(duration: 1, bounce: 0.9), value: animationAmount)
.animation(.easeInOut(duration: 2), value: animationAmount)
```

### attach modifiers directly to the animation to add a delay
```swift
.animation(
    .easeInOut(duration: 2)
        .delay(1),
    value: animationAmount
)
```
### setting `autoreverses`
creates a one-second animation that will bounce up and down before reaching its final size
```swift
.animation(
    .easeInOut(duration: 1)
        .repeatCount(3, autoreverses: true),
    value: animationAmount
)
```

### repeatForever() modifier
### overlay()
lets us create new views at the same size and position as the view we’re overlaying

animations that start immediately and continue animating for the life of the view
```swift
.overlay(
    Circle()
        .stroke(.red)
        .scaleEffect(animationAmount)
        .opacity(2 - animationAmount)
        .animation(
            .easeInOut(duration: 1)
                .repeatForever(autoreverses: false),
            value: animationAmount
        )
)
.onAppear {
    animationAmount = 2
}
```

## `animation()` modifier for other components
we don’t need to specify which value we’re watching for changes
```swift
Stepper("Scale amount", value: $animationAmount.animation(
    .easeInOut(duration: 1)
        .repeatCount(3, autoreverses: true)
), in: 1...10)
```

## rotation3DEffect() modifier
can be given a rotation amount in degrees as well as an axis that determines how the view rotates
```swift
.rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
```


```swift
struct ContentView: View {   
    var body: some View {
        Button("Tap Me") {
            withAnimation {
			    animationAmount += 360
			}
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
    }
}
```
bounciness
```swift
withAnimation(.spring(duration: 1, bounce: 0.5)) {
    animationAmount += 360
}
```
### `clipped()`
stops the view from being drawn outside of its rectangular space

# animation stack
- each animation controls everything before it up to the next animation
- it’s possible to disable animations entirely by passing `nil` to the modifier
```swift
Button("Tap Me") {
    enabled.toggle()
}
.frame(width: 200, height: 200)
.background(enabled ? .blue : .red)
.animation(nil, value: enabled)
.foregroundStyle(.white)
.clipShape(.rect(cornerRadius: enabled ? 60 : 0))
.animation(.spring(duration: 1, bounce: 0.6), value: enabled)
```

# gestures
store the amount of drag
```swift
@State private var dragAmount = CGSize.zero 
```

`offset()`
lets us adjust the X and Y coordinate of a view without moving other views around it

```swift
.offset(dragAmount)
.gesture(
    DragGesture()
        .onChanged { dragAmount = $0.translation }
        .onEnded { _ in dragAmount = .zero }
)
.animation(.bouncy, value: dragAmount)
```

or add animation only to .onEnded
```swift
.onEnded { _ in
    withAnimation(.bouncy) {
        dragAmount = .zero
    }
}
```

# transitions
### default view transition
```swift
withAnimation {
    isShowingRed.toggle()
}
```
### `transition()` modifier
```swift
Rectangle()
    .fill(.red)
    .frame(width: 200, height: 200)
    //.transition(.scale)
    .transition(.asymmetric(insertion: .scale, removal: .opacity))
```

#  custom transitions using ViewModifier
```swift
struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}
```

create extension:
```swift
extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}
```

attach the pivot animation to any view using this:
```swift
.transition(.pivot)
```