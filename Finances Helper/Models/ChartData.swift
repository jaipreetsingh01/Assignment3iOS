//
//  ChartData.swift
//  Finances Helper
//
//  Created by Jaipreet  on 10/05/24.
//

import Foundation
import SwiftUI

struct ChartData: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var color : Color
    var slicePercent : CGFloat = 0.0
    var persentage: Double = 0.0
    var value : Double
    var title: String
    var type: TransactionType = .income
    var cyrrencySymbol: String = "$"
    
    var friendlyTotal: String{
        value.formattedWithAbbreviations(symbol: cyrrencySymbol)
    }
}

extension ChartData {
    static var sample: [ChartData] {
        [ ChartData(color: .orange, slicePercent: 0.2967032967032967, persentage: 0.2967032967032967, value: 405.0, title: "Udemy"),
          ChartData(color: .mint, slicePercent: 0.7069597069597069, persentage: 0.41025641025641024, value: 560.0, title: "Kindle"),
          ChartData(color: .teal, slicePercent: 1.0, persentage: 0.29304029304029305, value: 400.0, title: "Medium")]
    }
}
