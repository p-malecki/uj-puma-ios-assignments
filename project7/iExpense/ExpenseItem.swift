
//
//  Created by Pawel Malecki for UJ PUMAIOS course 23/01/2024.
//

import SwiftData


@Model
class ExpenseItem: {  // project 12 challange #1
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    let currency: String
    
    init(id: UUID, name: String, type: String, amount: Double, currency: String) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
        self.currency = currency
    }
}
