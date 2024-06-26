//
// This is taken from github resource
// https://github.com/RaffiKian/RKCalendar

import SwiftUI

struct RKDate {
    
    var date: Date
    let rkManager: RKManager
    
    var isDisabled: Bool = false
    var isToday: Bool = false
    var isSelected: Bool = false
    var isBetweenStartAndEnd: Bool = false
    var endDate: Date?
    var startDate: Date?
    
    init(date: Date, rkManager: RKManager, isDisabled: Bool, isToday: Bool, isSelected: Bool, isBetweenStartAndEnd: Bool, endDate: Date? = nil, startDate: Date? = nil) {
        self.date = date
        self.endDate = endDate
        self.startDate = startDate
        self.rkManager = rkManager
        self.isDisabled = isDisabled
        self.isToday = isToday
        self.isSelected = isSelected
        self.isBetweenStartAndEnd = isBetweenStartAndEnd
    }
    
    var isEndDate: Bool{
        date == endDate
    }
    
    var isStartDate: Bool{
        date == startDate
    }
    
    func getText() -> String {
        let day = formatDate(date: date, calendar: self.rkManager.calendar)
        return day
    }
    
    func getTextColor() -> Color {
        var textColor = rkManager.colors.textColor
        if isDisabled {
            textColor = rkManager.colors.disabledColor
        } else if isSelected {
            textColor = rkManager.colors.selectedColor
        } else if isToday {
            textColor = rkManager.colors.todayColor
        } else if isBetweenStartAndEnd {
            textColor = rkManager.colors.betweenStartAndEndColor
        }
        return textColor
    }
    
    func getBackgroundColor() -> Color {
        var backgroundColor = rkManager.colors.textBackColor
        if isBetweenStartAndEnd {
            backgroundColor = rkManager.colors.betweenStartAndEndBackColor
        }
        if isDisabled {
            backgroundColor = rkManager.colors.disabledBackColor
        }
        if isSelected {
            backgroundColor = rkManager.colors.selectedBackColor
        }
        return backgroundColor
    }
    
    func getFontWeight() -> Font.Weight {
        var fontWeight = Font.Weight.medium
        if isDisabled {
            fontWeight = Font.Weight.thin
        } else if isSelected {
            fontWeight = Font.Weight.heavy
        } else if isToday {
            fontWeight = Font.Weight.heavy
        } else if isBetweenStartAndEnd {
            fontWeight = Font.Weight.heavy
        }
        return fontWeight
    }
    
    // MARK: - Date Formats
    
    func formatDate(date: Date, calendar: Calendar) -> String {
        let formatter = dateFormatter()
        return stringFrom(date: date, formatter: formatter, calendar: calendar)
    }
    
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "d"
        return formatter
    }
    
    func stringFrom(date: Date, formatter: DateFormatter, calendar: Calendar) -> String {
        if formatter.calendar != calendar {
            formatter.calendar = calendar
        }
        return formatter.string(from: date)
    }
}

