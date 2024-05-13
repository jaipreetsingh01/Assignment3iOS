//
//  CreateAccountViewModel.swift
//  Finances Helper
//
//  Created by Lance  on 10/05/24.
//


import Foundation
import SwiftUI
import CoreData

// Define CreateAccountViewModel as a final class with ObservableObject to integrate with SwiftUI
final class CreateAccountViewModel: ObservableObject{

    // Published properties to bind and react to UI changes
    @Published var title: String = ""
    @Published var balance: Double = 0.0
    @Published var color: Color = .red
    @Published var currencyCode: String = Locale.current.currency?.identifier ?? "USD"
    let isEditMode: Bool
    let coreDataManager: CoreDataManager
    let userService: UserService
    var editedAccount: AccountEntity?

    // Initialize with an optional AccountEntity to support editing existing accounts
    init(context: NSManagedObjectContext, account: AccountEntity?){
        
        self.coreDataManager = CoreDataManager(mainContext: context) // Initializes CoreDataManager with a context
        self.userService = UserService(context: context) // Initializes UserService with a context
        if let account{  // Check if an account is provided for editing
            title = account.title ?? ""
            balance = account.balance
            color = account.wrappedColor
            currencyCode = account.currencyCode ?? "USD"
            isEditMode = true
            editedAccount = account
            return
        }

        // Default to creation mode if no account is provided
        isEditMode = false
    }

    // Save method to determine whether to create a new account or update an existing one
    func save(onCreate: @escaping (String) -> Void){
        if isEditMode{
            update() // Call update if in edit mode
        }else{
            createAccount(onCreate) // Call createAccount if in creation mode
        }
    }

    // Remove an existing account
    func removeAccount(){
        guard let editedAccount else {return}
        AccountEntity.remove(editedAccount) // Remove the edited account using a static method
    }

    // Method to create a new account
    private func createAccount(_ onCreate: @escaping (String) -> Void){
        guard let user = userService.currentUser else { return }
        let newAccount = coreDataManager.createAccount(title: title, currencyCode: currencyCode, color: color.toHex() ?? "", balance: balance, members: Set([user]))
        onCreate(newAccount.id ?? "") // Callback with the new account ID
    }
    
    // Update the existing account with the current state
    private func update(){
        guard let editedAccount else {return}
        
        editedAccount.title = title
        editedAccount.balance = balance
        editedAccount.color = color.toHex()
        editedAccount.currencyCode = currencyCode
        
        coreDataManager.updateAccount(account: editedAccount) // Commit changes to Core Data
    }
    
}
