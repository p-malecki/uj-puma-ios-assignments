//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Student1 on 23/01/2024.
//

import SwiftData
import Foundation


@Model
class ExpenseItem {  // project 12 challange #1
    var name: String
    var type: String
    var amount: Double
    var currency: String
    
    init(name: String, type: String, amount: Double, currency: String) {
        self.name = name
        self.type = type
        self.amount = amount
        self.currency = currency
    }
}
