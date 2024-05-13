//
//  TransactionType.swift
//  Finances Helper
//
//  Created by Jaipreet  on 10/05/24.
//

import Foundation

enum TransactionType: String, Identifiable{
    case income = "INCOME"
    case expense = "EXPENSE"
    
    var id: String{ rawValue }
    
    var title: String{
        switch self {
        case .income: return "Income"
        case .expense: return "Expense"
        }
    }
}
