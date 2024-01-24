//
//  ContentView.swift
//  Instafilter
//
//  Created by Studen1 on 23/01/2024.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5

    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?

    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()

    @State private var showingFilterSheet = false
    @State private var isImageSelected = false // project 13 challange #1

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)

                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)

                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }

                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in applyProcessing() }
                        .disabled(isImageSelected) // project 13 challange #1
                }
                .padding(.vertical)
                
                HStack {
                    Text("Radius") // project 13 challange #2
                    Slider(value: $filterRadius)
                        .onChange(of: filterRadius) { _ in applyProcessing() }
                        .disabled(isImageSelected)
                }
                .padding(.vertical)
                
                HStack {
                    Text("Scale") // project 13 challange #2
                    Slider(value: $filterScale)
                        .onChange(of: filterScale) { _ in applyProcessing() }
                        .disabled(isImageSelected)
                }
                .padding(.vertical)
                              

                HStack {
                    Button("Change Filter") {
                        showingFilterSheet = true
                    }
                        .disabled(isImageSelected) // project 13 challange #1


                    Spacer()

                    Button("Save", action: save)
                        .disabled(isImageSelected) // project 13 challange #1
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in // project 13 challange #1
                loadImage()
                isImageSelected = (inputImage == nil)
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                // project 13 challange #3
                Button("Comic Effect") { setFilter(CIFilter.comicEffect()) }
                Button("Sharpen Luminance") { setFilter(CIFilter.sharpenLuminance()) }
                Button("Gloom") { setFilter(CIFilter.gloom()) }
                Button("Edge Work") { setFilter(CIFilter.edgeWork()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }


        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    func save() {
        guard let processedImage = processedImage else { return }

        let imageSaver = ImageSaver()

        imageSaver.successHandler = {
            print("Success!")
        }

        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }

        imageSaver.writeToPhotoAlbum(image: processedImage)
    }

    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }

    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
