//
//  DetailView.swift
//  Bookworm
//
//  Created by Paul Hudson on 23/11/2021.
//
//  Modified by Pawel Malecki for UJ PUMAIOS course on 09/01/2024.


import SwiftUI

struct DetailView: View {
    let book: Book

    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false

    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Mystery")  // project 11 challange #1
                    .resizable()
                    .scaledToFit()

                Text(book.genre?.uppercased() ?? "MYSTERY")  // project 11 challange #1
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }

            // project 11 challange #3
            Text(book.date, format: .dateTime.day().month().year())
                .foregroundColor(.secondary)
                .padding()

            Text(book.author ?? "Unknown Author")  // project 11 challange #1
                .font(.title)
                .foregroundColor(.secondary)

            Text(book.review ?? "No review")  // project 11 challange #1
                .padding()

            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        .navigationTitle(book.title ?? "Unknown Book")  // project 11 challange #1
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete book?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
    }

    func deleteBook() {
        moc.delete(book)

//        try? moc.save()
        dismiss()
    }
}

