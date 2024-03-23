//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Student1 on 06/12/2023.
//

import SwiftUI

struct FlagImage: View { // project 3 challange #2
    var img: String
    var body: some View {
        Image(img)
            .flagImageModified() // project 3 challange #3
    }
}

struct FlagImageModifier: ViewModifier {  // project 3 challange #3
  func body(content: Content) -> some View {
      content
          .clipShape(.capsule)
          .shadow(radius: 5)
    }
}

extension View {
    func flagImageModified() -> some View {  // project 3 challange #3
        modifier(FlagImageModifier())
    }
}


//extension AnyTransition {
//    static var pivot: AnyTransition {
//        .modifier(
//            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
//            identity: .opacity
//        )
//    }
//}


struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0 // project 2 challange #1

    @State private var userAnswer = 0
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var message = ""

    @State private var currentRound = 1
    @State private var endingGame = false // project 2 challange #3

    @State private var animateFlag360Spin = [0.0, 0.0, 0.0]
    @State private var animateFlagOpacity = [true, true, true]
    @State private var animateFlagSize = [1.0, 1.0, 1.0]

    let numberOfRounds = 8

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.5),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.5)
            ], center: .top, startRadius: 200, endRadius: 700)
            .blur(radius: 300, opaque: true)
            .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { selectedIndex in
                        Button {
                            withAnimation(.spring(duration: 1, bounce: 0.5)) {  // project 6 challange #1
                                animateFlag360Spin[selectedIndex] += 360
                            }
                            withAnimation(.spring().speed(0.2)) {  // project 6 challange #2
                                animateFlagOpacity.indices.forEach { index in
                                    animateFlagOpacity[index] = (index == selectedIndex)
                                    animateFlagSize[index] = (index == selectedIndex) ? animateFlagSize[index] : 0.5
                                }
                            }
                            flagTapped(selectedIndex)
                        } label: {
                            FlagImage(img: countries[selectedIndex]) // project 3 challange #3
                        }
                        .rotation3DEffect(.degrees(animateFlag360Spin[selectedIndex]), axis: (x: 0, y: 1, z: 0))
                        .opacity(animateFlagOpacity[selectedIndex] ? 1.0 : 0.25)
                        //.animation(nil, value: enabled)
                        .scaleEffect(animateFlagSize[selectedIndex])  // project 6 challange #3
                        .animation(.easeInOut(duration: 1), value: animateFlagSize[selectedIndex])
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: \(userScore)") // project 2 challange #1
                    .foregroundStyle(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: nextRound)
        } message: {
            Text("Your score is \(userScore) points.")
            Text(message)
        }
        .alert("THE END", isPresented: $endingGame) { // project 2 challange #3
            Button("Replay", action: nextRound)
            .buttonStyle(.borderedProminent)
            Button("Finish", role: .destructive, action: {})
            .buttonStyle(.bordered)
        } message: {
            Text("Good game!\nYour score is \(userScore) points.")
        }
    }

    func flagTapped(_ number: Int) {
        userAnswer = number
        if userAnswer == correctAnswer {
            scoreTitle = "Correct"
            userScore += 10
        } else {
            scoreTitle = "Wrong"
            message = "Wrong! That is the flag of \(countries[userAnswer])" // project 2 challange #2
            userScore -= 5
        }

        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func nextRound() {
        if (currentRound < numberOfRounds) {
            currentRound += 1
            
            animateFlag360Spin = [0.0, 0.0, 0.0]
            animateFlagOpacity = [true, true, true]
            animateFlagSize = [1.0, 1.0, 1.0]
        } else {
            currentRound = 0
            userScore = 0
            endingGame = true
        }
        askQuestion()
    }
}

#Preview {
    ContentView()
}
