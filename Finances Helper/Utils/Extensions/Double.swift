// code copied
// https://stackoverflow.com/questions/74258442/formatting-large-currency-numbers

import Foundation
extension Double{
    
    
    var twoNumString: String {
        String(format: "%.1f", self)
    }
    
    
    var treeNumString: String{
        if self.truncatingRemainder(dividingBy: 1) == 0{
            return String(format: "%.0f", self)
        }else{
           return String(format: "%.2f", self)
        }
    }
    
    func calculatePercentage(for total: Double) -> CGFloat{
        if self >= total {return 1}
        return self / total
    }
    
    func toCurrency(symbol: String?) -> String{
        twoNumString + (symbol ?? "$")
    }
    
    
// Convert a Double to a String with K, M, Bn, Tr abbreviations.
   
    func formattedWithAbbreviations(symbol: String) -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.treeNumString
            return "\(sign)\(stringFormatted)Tr \(symbol)"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.treeNumString
            return "\(sign)\(stringFormatted)Bn \(symbol)"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.treeNumString
            return "\(sign)\(stringFormatted)M \(symbol)"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.treeNumString
            return "\(sign)\(stringFormatted)K \(symbol)"
        default:
            return self.toCurrency(symbol: symbol)
        }
    }
}
