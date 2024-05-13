//
//  ContentView.swift
//  Finances Helper
//
//  Created by Jaipreet  on 10/05/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var rootVM: RootViewModel // root view model property in view's environment so all views can see changes to RootVM
    
    var body: some View {
        RootView() // content of view
            .environmentObject(rootVM) // rootVM environment object in view
            .preferredColorScheme(.light)
        
        // if no account, we will show create accound view (close button hidden)
            .fullScreenCover(isPresented: $rootVM.showCreateAccoutView) {
                NavigationStack{
                    CreateAccountView(rootVM: rootVM, hiddenClose: true)
                }
            }
    }
}

// just for preview - ignore 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RootViewModel(context: dev.viewContext))
    }
}
