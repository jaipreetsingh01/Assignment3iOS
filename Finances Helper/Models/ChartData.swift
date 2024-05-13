//
//  ChartData.swift
//  Finances Helper
//
//  Created by Jaipreet  on 10/05/24.
//

import Foundation
import SwiftUI

// chart variables 
struct ChartData: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var color : Color
    var slicePercent : CGFloat = 0.0
    var percentage: Double = 0.0
    var value : Double
    var title: String
    var type: TransactionType = .income
    var cyrrencySymbol: String = "$"
    
    var friendlyTotal: String{
        value.formattedWithAbbreviations(symbol: cyrrencySymbol)
    }
}


// this is used for the preview only , udemy kindle netflix psn etc etc 
extension ChartData {
    static var sample: [ChartData] {
        [ ChartData(color: .red, slicePercent: 0.2967032967032967, percentage: 0.2967032967032967, value: 405.0, title: "Netflix"),
          ChartData(color: .blue, slicePercent: 0.7069597069597069, percentage: 0.41025641025641024, value: 560.0, title: "PSN"),
          ChartData(color: .green, slicePercent: 1.0, percentage: 0.29304029304029305, value: 400.0, title: "ActivateUTS")]
    }
}
