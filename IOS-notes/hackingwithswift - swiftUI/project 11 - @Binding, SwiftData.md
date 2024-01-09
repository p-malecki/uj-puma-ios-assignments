# @Binding
___
## the big picture
`@State` property wrapper lets us work with local value types
`@Bindable` lets us make bindings to properties inside observable classes
`@Binding` lets us store a single mutable value in a view that actually points to some other value from elsewhere.

### toggle examaple
In the case of `Toggle`, the switch changes its own local binding to a Boolean, but behind the scenes that’s actually manipulating the `@State` property in our view – they are both reading and writing the same Boolean.
```swift
@State private var rememberMe = false

var body: some View {
    Toggle("Remember Me", isOn: $rememberMe)
}
```
### **`@Bindable` vs `@Binding`**
`@Bindable` is used when you're accessing a shared class that uses the `@Observable` macro: You create it using `@State` in one view, so you have bindings available there, but you use `@Bindable` when sharing it with other views so SwiftUI can create bindings there too.

`@Binding` is used when you have a simple, value type piece of data rather than a separate class.
it allows us to create a two-way connections

# TextField - multi-line text input
___
```swift
TextField("Enter your text", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .navigationTitle("Notes")
                .padding()
```
- it also expects to be given a two-way binding to a text string
- it can grow, just like the iMessage text box does

# SwiftData
___
#### SwiftData:
- is an object graph and persistence framework. 
- is capable of sorting and filtering of our data, and can work with much larger data – there’s effectively no limit to how much data it can store.
- implements iCloud syncing, lazy loading of data, undo and redo, and much more.

####  SwiftData model
```swift
import SwiftData

@Model
class Student {
var id: UUID
    var name: String

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
```

# `App` struct
___
`@main` tells Swift this is what launches our app

`WindowGroup` tells SwiftUI that our app can be displayed in many windows. (This doesn't do much on iPhone, but on iPad and macOS it becomes a lot more important.)

## create a model container
we need to add a modifier to the `WindowGroup` so that SwiftData is available everywhere in our app
```swift
import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
.modelContainer(for: Student.self) 
```
# @Query wrapper - loading data
___
SwiftData loads students from its model container – it automatically finds the main context that was placed into the environment, and queries the container through there. (get all of them)


Add this property to `ContentView`
```swift
@Query var students: [Student]
```

Add this property to `ContentView`
```swift
@Environment(\.modelContext) var modelContext
```

## sorting 
### simpler approach
```swift
@Query(sort: \Book.rating, order: .reverse) var books: [Book]
```
### SortDescriptor approach
sorting by backup field too
e.g. "sort by rating, then by title" adds an extra level of predictability to your app
```swift
@Query(sort: [
    SortDescriptor(\Book.title, order: .reverse),
    SortDescriptor(\Book.author)
]) var books: [Book]
```
You can specify more than one sort descriptor, and they will be applied in the order you provide them. (optional)

# inserting models 
```swift
modelContext.insert(student)
```
# deleting models
```swift
modelContext.delete(book)
```

# Preview for SwiftData models
trying to create a SwiftData model object without a container around is likely to make your code crash.
```swift
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(title: "Test Book", author: "Test Author", genre: "Fantasy", review: "This was a great book; I really enjoyed it.", rating: 4)

        return DetailView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
```


# .buttonStyle(.plain)
That makes SwiftUI treat each button individually for e.g. in star ratings.