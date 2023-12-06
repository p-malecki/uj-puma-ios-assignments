//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Paul Hudson on 11/10/2023.
//
//  Modified by Pawel Malecki for UJ PUMAIOS course on 06/12/2023.

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0

    @State private var didUserGuessedCorrectly = false
    @State private var userAnswer = 0
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var currentRound = 1
    @State private var endingGame = false

    let numberOfRounds = 8

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
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

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: ???")
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
            if (didUserGuessedCorrectly == false) {
                Text("Wrong! That is the flag of \(countries[userAnswer])")
            }
        }
        .alert("THE END", isPresented: $endingGame) {
            Button("Replay", action: nextRound)
            .buttonStyle(.borderedProminent)
            Button("Finish", role: .destructive)
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
            didUserGuessedCorrectly = true
        } else {
            scoreTitle = "Wrong"
            userScore -= 5
            didUserGuessedCorrectly = false
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
        } else {
            currentRound = 0
            endingGame = true
        }
        askQuestion()
    }
}

#Preview {
    ContentView()
}