
# async load data
___
```swift
struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}
```
## create URL
```swift
guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
    print("Invalid URL")
    return
}
```

### fetch the data from URL - URLSession
```swift
let (data, _) = try await URLSession.shared.data(from: url)
```
### decode
```swift
if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
    results = decodedResponse.results
}
```
## async func
```swift
func loadData() async {

}
```

and use:
```swift
.task {
    await loadData()
}
```

# AsyncImage
___
```swift
AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
    .resizable()
    .frame(width: 200, height: 200)
```
with placeholder
```swift
AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
    image
        .resizable()
        .scaledToFit()
} placeholder: {
    Color.red
}
.frame(width: 200, height: 200)
```
with phase.image
```swift
AsyncImage(url: URL(string: "https://hws.dev/img/bad.png")) { phase in
    if let image = phase.image {
        image
            .resizable()
            .scaledToFit()
    } else if phase.error != nil {
        Text("There was an error loading the image.")
    } else {
        ProgressView()
    }
}
.frame(width: 200, height: 200)
```

#  disabled() modifier
___
```swift
struct ContentView: View {
    @State private var username = ""
    @State private var email = ""

	var disableForm: Bool {
	    username.count < 5 || email.count < 5
	}

    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }

            Section {
                Button("Create account") {
                    print("Creating account…")
                }
            }.disabled(disableForm)
        }
    }
}
```

#  Codable conformance to an @Observable class
___
`@Observable` macro is quietly rewriting our class so that it can be monitored by SwiftUI

we need to tell Swift exactly how it should encode and decode our data
the enum is called `CodingKeys` and the protocol is `CodingKey`
`_name` – the underlying storage for our `name` property
```swift
@Observable
class User: Codable {
    enum CodingKeys: String, CodingKey {
        case _name = "name"
    }

    var name = "Taylor"
}
```

 ```swift
struct ContentView: View {
    var body: some View {
        Button("Encode Taylor", action: encodeTaylor)
    }

    func encodeTaylor() {
        let data = try! JSONEncoder().encode(User())
        let str = String(decoding: data, as: UTF8.self)
        print(str)
    }
}
```
This coding key mapping works both ways: when `Codable` sees `name` in some JSON, it will automatically be saved in the `_name` property.

# haptic effects
___
```swift
Button("Tap Count: \(counter)") {
	counter += 1
}
.sensoryFeedback(.increase, trigger: counter)
.sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: counter)
```

## CoreHaptics
```swift
import CoreHaptics
@State private var engine: CHHapticEngine?

func prepareHaptics() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

    do {
        engine = try CHHapticEngine()
        try engine?.start()
    } catch {
        print("There was an error creating the engine: \(error.localizedDescription)")
    }
}

func complexSuccess() {
    // make sure that the device supports haptics
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
    var events = [CHHapticEvent]()

    // create one intense, sharp tap
    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
    events.append(event)

    // convert those events into a pattern and play it immediately
    do {
        let pattern = try CHHapticPattern(events: events, parameters: [])
        let player = try engine?.makePlayer(with: pattern)
        try player?.start(atTime: 0)
    } catch {
        print("Failed to play pattern: \(error.localizedDescription).")
    }
}
```

```swift
Button("Tap Me", action: complexSuccess)
    .onAppear(perform: prepareHaptics)
```

# Toggle
___
```swift
Toggle("Add extra frosting", isOn: $order.extraFrosting)
```

# @Bindable
___
We haven't use `@State` in `AddressView` because we aren't creating the class here, we're just receiving it from elsewhere. This means SwiftUI doesn't have access to the same two-way bindings we'd normally use, which is a problem.
_we_ know this class uses the `@Observable` macro, which means SwiftUI is able to watch this data for changes. So, what the `@Bindable` property wrapper does is create the missing bindings for us – it produces two-way bindings that are able to work with the `@Observable` macro, _without_ having to use `@State` to create local data
```swift
@Bindable var order: Order
```

# scrollBounceBehavior() modifier
____
disable bounce when there is nothing to scroll in ScrollView
```swift
.scrollBounceBehavior(.basedOnSize)
```