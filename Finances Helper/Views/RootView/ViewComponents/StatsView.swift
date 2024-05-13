//
//  StatsView.swift
//  Finances Helper
//
//  Created by Jaipreet  on 10/05/24.
//

import SwiftUI

struct StatsView: View {
    @Binding var isExpand: Bool
    @Namespace var animation // animating view transitions
    @ObservedObject var rootVM: RootViewModel
    var chartData: [ChartData]
    var body: some View {
        // views on top of each other - stat view, state stuff , DONUT CHART is from viewComponents
        ZStack(alignment: .top){
            ZStack(alignment: .center){
                    DonutChart(chartData: chartData)
                        .frame(height: 200)
                        .padding(.vertical, 20)
                        .matchedGeometryEffect(id: "CHART", in: animation)
                        .transition(.scale.combined(with: .opacity))
                
            }
            .padding(.top, 90)
            .padding([.bottom, .horizontal])
            
            VStack(spacing: 10) {
                datePickerButtons
                dateTitle
            }
            .hCenter()
            .padding([.horizontal, .top])
            .background(Color.white)
        }
        .hCenter()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5)
        .overlay(alignment: .bottomTrailing) {
            Button {
                rootVM.addTransaction()
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .imageScale(.large)
                    .padding()
                    .background(Color.blue, in: Circle())
            }
            
            .scaleEffect(1)
            .padding(16)
        }
        
// @jp - Animating the + icon button on isExpand, this has issues
//        .onChange(of: isExpand) { expand in
//            withAnimation(.easeInOut(duration: 0.3)) {
//            }
//        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color(.systemGray6)
            StatsView(isExpand: .constant(false), rootVM: RootViewModel(context: dev.viewContext), chartData: ChartData.sample)
                .padding()
        }
    }
}

extension StatsView{
    
    private var dateTitle: some View{
        Text(rootVM.timeFilter.navTitle ?? "")
            .font(.subheadline.bold())
    }
    
    private var datePickerButtons: some View{
        HStack(spacing: 20) {
            // for the 5 scenaiors we have  label, on tap - set as active filter
            ForEach(TransactionTimeFilter.allCases) { type in
                labelView(type)
                    .onTapGesture {
                        rootVM.timeFilter = type
                    }
            }
            
            // special - case , if this is selected we toggle the boolean which will display the calender
            labelView(TransactionTimeFilter.select(.now, .now))
                .onTapGesture {
                    rootVM.showDatePicker.toggle()
                }
        }
        .animation(.spring(), value: rootVM.timeFilter)
    }
    
    private func labelView(_ type: TransactionTimeFilter) -> some View{
        Text(type.title)
            .font(.headline)
            .foregroundColor(rootVM.timeFilter.id == type.id ? Color.black : .secondary)
            .padding(.bottom, 5)
            .overlay(alignment: .bottom) {
                if rootVM.timeFilter.id == type.id {
                    RoundedRectangle(cornerRadius: 2)
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "DATE_TAB", in: animation)
                }
            }
            .padding(.vertical, 5)
    }
}
