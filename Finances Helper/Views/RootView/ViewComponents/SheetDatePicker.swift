//
//  SheetDatePicker.swift
//  Finances Helper
//
//  Created by Jaipreet  on 10/05/24.
//

import SwiftUI

struct SheetDatePicker: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var rootVM: RootViewModel
    @State var selectedDate = Date.now.noon
    var body: some View {
        VStack {
            HStack{
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                Spacer()
            }
            CustomDatePickerView(selectedDate: $selectedDate)
                .padding(.top)
            Spacer()
        }
        .padding()
//        .onChange(of: selectedDate) { newValue in
//            rootVM.timeFilter = .select(newValue)
//            dismiss()
//        }
    }
}

struct SheetDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        SheetDatePicker(rootVM: RootViewModel(context: dev.viewContext))
    }
}
