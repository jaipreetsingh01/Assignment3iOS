//
//  SideMenuView.swift
//  Finances Helper
//
//  Created by Jaipreet  on 10/05/24.
//

import SwiftUI

struct SideMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var profileMV: SideMenuViewModel
    @ObservedObject var rootVM: RootViewModel
    
    init(rootVM: RootViewModel) {
        self._profileMV = StateObject(wrappedValue: SideMenuViewModel(context: rootVM.coreDataManager.mainContext))
        self.rootVM = rootVM
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                headerView
                ForEach(SideMenuView.Menu.allCases, id: \.self){type in
                    Group{
                        if type.isButton{
                            Button {
                                buttonTapped(type)
                            } label: {
                                rowView(type)
                            }
                        }else{
                            NavigationLink(value: type) {
                               rowView(type)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
            .navigationDestination(for: SideMenuView.Menu.self) { type in
                switch type{
                case .accounts:
                    AccountsListView(rootVM: rootVM)
                case.blank:
                    Text("Team Members: ")
                case .team1:
                    Text("Jaipreet Singh")
                    Text("24900577")
                case .team2:
                    Text("Lance Derona")
                    Text("24684817")
                case .team3:
                    Text("Kendrick Junio")
                    Text("25118314")
                default:
                    EmptyView()
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(rootVM: RootViewModel(context: dev.viewContext))
    }
}

extension SideMenuView {
    
    
    private func rowView(_ type: SideMenuView.Menu) -> some View{
        Text(type.title)
            .foregroundColor(.black)
            .font(.system(size: 18).weight(.medium))
            .hLeading()
    }
    
    private var headerView: some View{
        HStack(alignment: .top) {
            Button {
                
            } label: {
                HStack(spacing: 15){
                    Image("uts_logo")
                        .resizable()
                        .frame(width: 86, height: 38)
                        .foregroundColor(Color(.systemGray4))
                    Text("Assignment 3")
                        .font(.title3.weight(.medium))
                    Spacer()
                }
            }
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }
        }
        .foregroundColor(.black)
        .padding(.bottom)
    }
    
    enum Menu: Int, CaseIterable{
        case main, accounts,  blank, team1, team2, team3
        
        var title: String{
            switch self{
            case .main:
                return "Main"
            case .accounts:
                return "Accounts"
            case .blank:
                return "\n \nTeam Members: "
            case .team1:
                return "Jaipreet Singh"
            case .team2:
                return "Lance Derona"
            case .team3:
                return "Kendrick Junio"
            }
        }
        
        var isButton: Bool{
            switch self{
            case .main:
                return true
            case .accounts, .blank, .team1, .team2, .team3:
                return false
            }
        }
    }
    
    private func buttonTapped(_ type: SideMenuView.Menu){
        switch type{
        case .main:
            dismiss()
        default: break
        }
    }
    
    
}
