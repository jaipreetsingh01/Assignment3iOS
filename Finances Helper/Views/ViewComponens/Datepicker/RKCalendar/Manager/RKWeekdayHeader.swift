// This is taken from github resource
// https://github.com/RaffiKian/RKCalendar
import SwiftUI

struct RKWeekdayHeader : View {
    
    var rkManager: RKManager
     
    var body: some View {
        HStack(alignment: .center) {
            ForEach(self.getWeekdayHeaders(calendar: self.rkManager.calendar), id: \.self) { weekday in
                Text(weekday)
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(self.rkManager.colors.weekdayHeaderColor)
            }
        }.background(rkManager.colors.weekdayHeaderBackColor)
    }
    
    func getWeekdayHeaders(calendar: Calendar) -> [String] {
        
        let formatter = DateFormatter()
        
        var weekdaySymbols = formatter.shortStandaloneWeekdaySymbols
        let weekdaySymbolsCount = weekdaySymbols?.count ?? 0
        
        for _ in 0 ..< (1 - calendar.firstWeekday + weekdaySymbolsCount){
            let lastObject = weekdaySymbols?.last
            weekdaySymbols?.removeLast()
            weekdaySymbols?.insert(lastObject!, at: 0)
        }
        
        return weekdaySymbols ?? []
    }
}

#if DEBUG
struct RKWeekdayHeader_Previews : PreviewProvider {
    static var previews: some View {
        RKWeekdayHeader(rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365)))
    }
}
#endif

