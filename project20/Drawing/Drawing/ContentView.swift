//
//  ContentView.swift
//  Drawing
//
//  Created by Student1 on 24/01/2024.
//

import SwiftUI

struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let h = rect.height
        let w = rect.width
        let hh = h * 0.5
        let ww = w * 0.1
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - hh))
        path.addLine(to: CGPoint(x: rect.midX - ww, y: rect.maxY - hh))
        path.addLine(to: CGPoint(x: rect.midX - ww, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + ww, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + ww, y: rect.maxY - hh))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - hh))
        path.closeSubpath()
        
        return path
    }
}


struct ColorCyclingRectangle: View {
    var amount = 0.0
    let steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<100) { value in
                Rectangle()
                    .inset(by: Double(value))
                    .strokeBorder(color(for: value, brightness: 1), lineWidth: 2)
            }
        }
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetValue = Double(value) / Double(steps) + amount

        if targetValue > 1 {
            targetValue -= 1
        }

        return Color(hue: targetValue, saturation: targetValue, brightness: brightness)
    }
}


struct ContentView: View {
    
    @State private var shapeThickness = 10.0
    @State private var colorRectangle = 0.0

    var body: some View {
        VStack {
            Arrow()
                .fill(.green)
                .stroke(.red, lineWidth: shapeThickness)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    withAnimation {
                        shapeThickness = Double.random(in: 0...20)
                    }
                }
            
            Slider(value: $shapeThickness, in: 0...20)
                .padding()
            
            ColorCyclingRectangle(amount: colorRectangle)
                            .frame(width: 300, height: 300)
            
            Slider(value: $colorRectangle, in: 0...2)
                .padding()
        }
        .padding()
    }
    
    
}

#Preview {
    ContentView()
}
