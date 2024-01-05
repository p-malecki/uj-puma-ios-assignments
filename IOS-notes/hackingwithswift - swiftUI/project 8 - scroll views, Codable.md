# images resizing
___
## scale fit/fill to frame
```swift
Image(.example)
    .resizable()
    .scaledToFit() // .scaledToFill()
    .frame(width: 300, height: 300)
```

## relative frame
frame relative to the horizontal size of its parent
```swift
Image(.example)
    .resizable()
    .scaledToFit()
    .containerRelativeFrame(.horizontal) { size, axis in
        size * 0.8
    }
```

# ScrollView
___
### LazyVStack
won’t create views until they are actually shown, and so minimize the amount of system resources being used
```swift
ScrollView { // (.horizontal)
    LazyVStack(spacing: 10) {  // LazyHStack
        ForEach(0..<100) {
            CustomText("Item \($0)")
                .font(.title)
        }
    }
}
```
# NavigationLink
___
creates new views from the current one
if you want something other than a simple text view as your label, you can use two trailing closures
```swift
NavigationStack {
    NavigationLink {
        Text("Detail View")
    } label: {
        VStack {
            Text("This is the label")
            Text("So is this")
            Image(systemName: "face.smiling")
        }
        .font(.largeTitle)
    }
}
```
`NavigationLink` is for showing details about the user’s selection, digging deeper into a topic
`sheet()` is for showing unrelated content, such as settings or a compose window

# hierarchical Codable
___
string of JSON
```swift
{
	"name": "Taylor Swift",
	"address": {
		"street": "555, Taylor Swift Avenue",
		"city": "Nashville"
	}
}
```
and structs that match defined JSON
```swift
struct User: Codable {
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let city: String
}
```

convert our JSON string to the `Data` type (which is what `Codable` works with)
then decode that into a `User` instance
```swift
let data = Data(input.utf8)
let decoder = JSONDecoder()
if let user = try? decoder.decode(User.self, from: data) {
    print(user.address.street)
}
```

# columns in grid
___
## fixed columns
```swift
let layout = [
    GridItem(.fixed(80)),
    GridItem(.fixed(80)),
    GridItem(.fixed(80))
]
```
## adaptive columns
they allow grids that make maximum use of available screen space
```swift
let layout = [
    GridItem(.adaptive(minimum: 80, maximum: 120)),
]
```

## columns in LazyVGrid
```swift
ScrollView {
    LazyVGrid(columns: layout) {
        ForEach(0..<1000) {
            Text("Item \($0)")
        }
    }
}
```


# generics conforming protocol
___
```swift
decode<T: Codable>
```

# Color-Theme extension
___
extension that allows us to use those colors everywhere SwiftUI expects a `ShapeStyle`
```swift
extension ShapeStyle where Self == Color {
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }

    static var lightBackground: Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
}
```

## force dark mode
`NavigationStack`, and will appear either black or white depending on whether the user is in light mode or dark mode
To fix this, we can tell SwiftUI our view prefers to be in dark mode _always_
```swift
.preferredColorScheme(.dark)
```