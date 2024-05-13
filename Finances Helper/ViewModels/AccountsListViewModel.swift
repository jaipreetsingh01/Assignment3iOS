//
//  AccountsListViewModel.swift
//  Finances Helper
//
//  Created by Lance on 10/05/24.
//


import Foundation
import CoreData

// Declare AccountsListViewModel as an observable object to work with SwiftUI
class AccountsListViewModel: ObservableObject{
    
    @Published var accounts = [AccountEntity]() // Published property to notify views when the list of accounts changes
    
    private var cancelBag = CancelBag() // A utility object to manage cancellation of all subscriptions
    let accountStore: ResourceStore<AccountEntity> // A store that handles fetching and updating AccountEntity instances

    
    init(context: NSManagedObjectContext){ // Initialize with a Core Data context
        self.accountStore = ResourceStore(context: context) // Initialize the account store
        
        startAccountsSubs() // Start observing changes in the account data
        fetchAccounts() // Fetch initial list of accounts
    }

    // Deinitializer to cancel any ongoing data subscriptions when the view model is deallocated
    deinit{
        cancelBag.cancel()
    }

    // Fetch all accounts from CoreData and update the accountStore
    private func fetchAccounts(){
        let request = AccountEntity.requestAll() // Prepare a fetch request for all accounts
        accountStore.fetch(request) // Use accountStore to execute the fetch request
    }

    // Setup subscriptions to listen for changes in account data
    private func startAccountsSubs(){
        accountStore.resources
            .dropFirst() // Ignore the first emission since it can be initial or default data
            .sink { accounts in
                self.accounts = accounts // Update local accounts array whenever the store emits new data
            }
            .store(in: cancelBag) // Store the subscription in cancelBag to manage its lifecycle
    }

    // Function to remove an account entity
    func removeAccount(_ item: AccountEntity){
        AccountEntity.remove(item) // Static method call to remove the account from CoreData
    }
    
}
