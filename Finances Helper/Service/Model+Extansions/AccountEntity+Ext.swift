//
//  AccountEntity+Ext.swift
//  Finances Helper
//
//  Created by Lance  on 10/05/24
//


import Foundation
import CoreData
import SwiftUI

// Extending AccountEntity to add computed properties and static methods
extension AccountEntity{
    
    // Returns the account balance as a formatted string with a currency symbol
    var friendlyBalance: String {
        balance.formattedWithAbbreviations(symbol: currencySymbol)
    }
    
    // Returns the Currency object for the account's currency code, defaults to USD if not set
    var currency: Currency? {
        Currency.currency(for: currencyCode ?? "USD")
    }
    
    // Provides a color representation based on the balance; positive balances are green, negative are red
    var balanceColor: Color {
        balance > 0 ? .green : .red
    }
    
    // Retrieves the shortest form of the currency symbol, defaults to "$" if not available
    var currencySymbol: String {
        currency?.shortestSymbol ?? "$"
    }
    
    // Returns a Color object from a hex code stored in the color property, defaults to blue if not available
    var wrappedColor: Color {
        guard let color else { return .blue }
        return Color(hex: color)
    }
    
    // Creates a new AccountEntity with specified properties and saves it to the provided Core Data context
    static func create(title: String, currencyCode: String, balance: Double, color: String, members: Set<UserEntity>, context: NSManagedObjectContext) -> AccountEntity {
        let entity = AccountEntity(context: context)
        entity.id = UUID().uuidString // Assigns a unique identifier
        entity.createAt = Date.now // Sets the creation date to the current time
        entity.title = title
        entity.currencyCode = currencyCode
        entity.balance = balance
        entity.color = color
        entity.members = members as NSSet // Stores members related to this account
        entity.creatorId = members.first?.id ?? "" // Sets the creator ID to the ID of the first member, if available
        entity.transactions = [] // Initializes transactions as an empty array
        
        context.saveContext() // Saves changes to the Core Data context
        
        return entity
    }
    
    // Updates and saves changes to an existing AccountEntity in its Core Data context
    static func updateAccount(for account: AccountEntity) {
        guard let context = account.managedObjectContext else { return }
        context.saveContext()
    }
    
    // Returns a fetch request for all AccountEntity instances sorted by creation date
    static func requestAll() -> NSFetchRequest<AccountEntity> {
        let fetchRequest = NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: true)]
        fetchRequest.propertiesToFetch = ["id", "currencyCode", "title", "balance"]
        return fetchRequest
    }
    
    // Returns a fetch request for an AccountEntity instance by its identifier
    static func request(for id: String) -> NSFetchRequest<AccountEntity> {
        let fetchRequest = NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id == %@", id) // Filters fetch request by ID
        fetchRequest.propertiesToFetch = ["id", "currencyCode", "title", "balance"]
        return fetchRequest
    }
    
    // Deletes the specified AccountEntity from its Core Data context and saves the context
    static func remove(_ item: AccountEntity) {
        guard let context = item.managedObjectContext else { return }
        context.delete(item)
        context.saveContext()
    }
    
}
