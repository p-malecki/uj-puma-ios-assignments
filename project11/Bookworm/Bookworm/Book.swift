//
//  Book.swift
//  Bookworm
//
//  Created by Student1 on 09/01/2024.
//

import Foundation
import SwiftData


@Model
class Book {
    var title: String
    var author: String
    var genre: String 
    var review: String
    var rating: Int16
    var date: Date // project 11 challange #3
    
    init(title: String, author: String, genre: String, review: String, rating: Int16, date: Date) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
        self.date = date
    }
}
