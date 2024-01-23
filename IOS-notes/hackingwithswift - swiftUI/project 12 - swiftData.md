SwiftData's model objects are powered by the same observation system that makes `@Observable` classes work, which means changes to your model objects are automatically picked up by SwiftUI so that our data and our user interface stay in sync.
This support extends to the `@Bindable` property wrapper, we get  straightforward object editing.

### bindings to objects in different views using @Bindable
```swift
struct EditUserView: View {
    @Bindable var user: User

    var body: some View {
        Form {
            TextField("Name", text: $user.name)
        }
    }
}
```

```swift
@Environment(\.modelContext) var modelContext
@Query(sort: \User.name) var users: [User]
@State private var path = [User]()
```



# @Query, Predicate
```swift
@Query(filter: #Predicate<User> { user in
    user.name.localizedStandardContains("R") &&
    user.city == "London"
}, sort: \User.name) var users: [User]
```

```swift
@Query(filter: #Predicate<User> { user in
    if user.name.localizedStandardContains("R") {
        if user.city == "London" {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}, sort: \User.name) var users: [User]
```
### Dynamically sorting and filtering
```swift
struct UsersView: View {
    @Query var users: [User]
    ...
```
```swift
init(minimumJoinDate: Date) {
    _users = Query(filter: #Predicate<User> { user in
        user.joinDate >= minimumJoinDate
    }, sort: \User.name)
}
```

```swift
UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast)
```

sorting:
```swift
init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
    _users = Query(filter: #Predicate<User> { user in
        user.joinDate >= minimumJoinDate
    }, sort: sortOrder)
}
```
```swift
UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
    .modelContainer(for: User.self)
```

```swift
@State private var sortOrder = [
    SortDescriptor(\User.name),
    SortDescriptor(\User.joinDate),
]
```
```swift
UsersView(minimumJoinDate: showingNewOnly ? .now : .distantPast, sortOrder: sortOrder)
```
# Tag()
modifier called `tag()`, which lets us attach specific values of our choosing to each picker option
```swift
Picker("Sort", selection: $sortOrder) {
    Text("Sort by Name")
        .tag([
            SortDescriptor(\User.name),
            SortDescriptor(\User.joinDate),
        ])

    Text("Sort by Join Date")
        .tag([
            SortDescriptor(\User.joinDate),
            SortDescriptor(\User.name)
        ])
}
```

# menu view
```swift
Menu("Sort", systemImage: "arrow.up.arrow.down") {
    // current picker code
}
```

# `@Relationship` macro
The default delete rule is called `.nullify`.
 _Cascade_   delete keeps going on deleting for all related objects.
 
 ```swift
@Relationship(deleteRule: .cascade) var jobs = [Job]()
```