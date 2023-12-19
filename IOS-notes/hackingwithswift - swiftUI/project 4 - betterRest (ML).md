## user input
- +-
```swift
Stepper("\(sleepAmount) hours", value: $sleepAmount, in: 4...12, step: 0.25)
```

## dates
- **DatePicker**
```swift
DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
.labelsHidden()
```
`in` parameter that works just the same as with `Stepper`

- `**DateComponents**`, which lets us read or write specific parts of a date rather than the whole thing
```swift
var components = DateComponents()
components.hour = 8
components.minute = 0
let date = Calendar.current.date(from: components) ?? .now
```

```swift
let components = Calendar.current.dateComponents([.hour, .minute], from: someDate)
let hour = components.hour ?? 0
let minute = components.minute ?? 0
```

- **formatting**
```swift
Text(Date.now, format: .dateTime.day().month().year())
```
 we’re _asking_ for that data, not _arranging_ it, and iOS will automatically format that data using the user’s preferences.
- alternative formatting
```swift
Text(Date.now.formatted(date: .long, time: .shortened))
```
## Create ML
 *lets us create custom machine learning models of our own*
 (using a dedicated Create ML app that makes the whole process drag and drop)


##  Core ML
*lets us make apps using machine learning*

**tabular regression** - we can throw a load of spreadsheet-like data at Create ML and ask it to figure out the relationship between various values

.mlmodel files

```swift
import CoreML
```

using Core ML can throw errors in two places: loading the model as seen above, but also when we ask for predictions so use do/catch blocks

## computed property
```swift
@State private var wakeUp = defaultWakeTime

static var defaultWakeTime: Date {
    var components = DateComponents()
    components.hour = 7
    components.minute = 0
    return Calendar.current.date(from: components) ?? .now
}
```

## pluralization
```swift
Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
```
word "cup" needs to be inflected to match whatever is in the `coffeeAmount` variable
"cup" to "cups" as appropriate

