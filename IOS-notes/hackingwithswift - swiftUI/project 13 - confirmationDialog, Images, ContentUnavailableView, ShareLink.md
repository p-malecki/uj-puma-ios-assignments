# onChange() modifier
```swift
Slider(value: $blurAmount, in: 0...20)
	.onChange(of: blurAmount) { oldValue, newValue in
		print("New value is \(newValue)")
	}
```

# confirmationDialog()
accepts three parameters: a title, a binding that decides whether the dialog is currently presented or not, and a closure that provides the buttons that should be shown – usually provided as a trailing closure
```swift
.confirmationDialog("Change background", isPresented: $showingConfirmation) {
    Button("Red") { backgroundColor = .red }
    Button("Green") { backgroundColor = .green }
    Button("Blue") { backgroundColor = .blue }
    Button("Cancel", role: .cancel) { }
} message: {
    Text("Select a new color")
}
```

# image types:
- `UIImage`, which comes from UIKit. This is an extremely powerful image type capable of working with a variety of image types, including bitmaps (like PNG), vectors (like SVG), and even sequences that form an animation. `UIImage` is the standard image type for UIKit, and of the three it’s closest to SwiftUI’s `Image` type.
- `CGImage`, which comes from Core Graphics. This is a simpler image type that is really just a two-dimensional array of pixels.
- `CIImage`, which comes from Core Image. This stores all the information required to produce an image but doesn’t actually turn that into pixels unless it’s asked to. Apple calls `CIImage` “an image recipe” rather than an actual image.

- We can create a `UIImage` from a `CGImage`, and create a `CGImage` from a `UIImage`.
- We can create a `CIImage` from a `UIImage` and from a `CGImage`, and can create a `CGImage` from a `CIImage`.
- We can create a SwiftUI `Image` from both a `UIImage` and a `CGImage`.

# CIFilter
```swift
import CoreImage
import CoreImage.CIFilterBuiltins

let context = CIContext()
let currentFilter = CIFilter.sepiaTone()

currentFilter.inputImage = beginImage
currentFilter.intensity = 1

```
 we need to convert the output from our filter to a SwiftUI `Image` that we can display in our view
 ```swift
// get a CIImage from our filter or exit if that fails
guard let outputImage = currentFilter.outputImage else { return }

// attempt to get a CGImage from our CIImage
guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

// convert that to a UIImage
let uiImage = UIImage(cgImage: cgImage)

// and convert that to a SwiftUI image
image = Image(uiImage: uiImage)
```

## the modern API
```swift
let currentFilter = CIFilter.twirlDistortion()
currentFilter.inputImage = beginImage
currentFilter.radius = 1000
currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
```
## the older API
it lets us set values dynamically – we can literally ask the current filter what values it supports, then send them on in
```swift
let currentFilter = CIFilter.twirlDistortion()
currentFilter.inputImage = beginImage

let amount = 1.0

let inputKeys = currentFilter.inputKeys

if inputKeys.contains(kCIInputIntensityKey) {
    currentFilter.setValue(amount, forKey: kCIInputIntensityKey) }
if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey) }
if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey) }
```

# ContentUnavailableView 
shows a standard user interface for when your app has nothing to display
```swift
ContentUnavailableView {
    Label("No snippets", systemImage: "swift")
} description: {
    Text("You don't have any saved snippets yet.")
} actions: {
    Button("Create Snippet") {
        // create a snippet
    }
    .buttonStyle(.borderedProminent)
}
```
# Loading photos from the user's photo library
```swift
import PhotosUI
import SwiftUI

@State private var pickerItems = [PhotosPickerItem]()
@State private var selectedImages = [Image]()

var body: some View {
	VStack {
		PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .images) {
		    Label("Select a picture", systemImage: "photo")
		}
	
		ScrollView {
		    ForEach(0..<selectedImages.count, id: \.self) { i in
		        selectedImages[i]
		            .resizable()
		            .scaledToFit()
		    }
		}
	}
	.onChange(of: pickerItems) {
	    Task {
	        selectedImages.removeAll()
	
	        for item in pickerItems {
	            if let loadedImage = try await item.loadTransferable(type: Image.self) {
	                selectedImages.append(loadedImage)
	            }
	        }
	    }
	}
}
```

# writeToPhotoAlbum
```swift
class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?

    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}
```

# ShareLink
```swift
ShareLink(item: URL(string: "https://www.hackingwithswift.com")!)
```
 
 attach a subject and message to the shared data:
```swift
ShareLink(item: URL(string: "https://www.hackingwithswift.com")!, subject: Text("Learn Swift here"), message: Text("Check out the 100 Days of SwiftUI!"))
```
you can customize the button itself by providing whatever label you want
```swift
ShareLink(item: URL(string: "https://www.hackingwithswift.com")!) {
    Label("Spread the word about Swift", systemImage: "swift")
}
```

### SharePreview
provide a preview to attach, which is important when you're sharing something more complex
```swift
let example = Image(.example)

ShareLink(item: example, preview: SharePreview("Singapore Airport", image: example)) {
    Label("Click to share", systemImage: "airplane")
}
```

# .requestReview

```swift
1. import StoreKit

2. @Environment(\.requestReview) var requestReview

3.
Button("Leave a review") {
    requestReview()
}
```

