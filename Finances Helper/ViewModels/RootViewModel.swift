//
//  RootViewModel.swift
//  Finances Helper
//
//  Created by Jaipreet  on 10/05/24.
//

import Foundation
import CoreData
import Combine
import SwiftUI

final class RootViewModel: ObservableObject{
    
    @AppStorage("activeAccountId") var activeAccountId: String = "" // store recieve from user dedaults
    @AppStorage("savedTimeFilter") var savedTimeFilter: String = ""
    
    @Published private(set) var activeAccount: AccountEntity? // current coount
    @Published private(set) var statsData = TransactionStatData() // stat data of transaction
    @Published var showSettingsView: Bool = false
    @Published var showCreateAccoutView: Bool = false
    @Published var selectedCategory: CategoryEntity?
    @Published var currentTab: TransactionType = .expense // current tab expense or income
    @Published var timeFilter: TransactionTimeFilter = .day // deafult time - today, can be week , month etc
    @Published var transactionFullScreen: TransactionType?
    @Published var showDatePicker: Bool = false // calender to pick hidden by default
    
    // manage core data & entities
    let coreDataManager: CoreDataManager
    let userService: UserService
    private let transactionStore: ResourceStore<TransactionEntity>
    private let accountStore: ResourceStore<AccountEntity>
    private var cancelBag = CancelBag()
    
    init(context: NSManagedObjectContext){
        userService = UserService(context: context)
        coreDataManager = CoreDataManager(mainContext: context)
        accountStore = ResourceStore(context: context)
        transactionStore = ResourceStore(context: context)
    
        startSubsAccount()
    
        fetchAccount()
        
        startSubsTransaction()
        
        startDateSubsTransaction()
        
        setTimeFilter()
        
    }
    
    
    func selectCategory(_ category: CategoryEntity){
        selectedCategory = category
    }
    

    func addTransaction(){
        self.transactionFullScreen = currentTab
    }
    
//    func generateCSV(){
//        if currentTab == .expense{
//            Helper.generateCSV(statsData.expenseTransactions)
//        }else{
//            Helper.generateCSV(statsData.incomeTransactions)
//        }
//    }
   
}


extension RootViewModel{
    
    // fecthing transaction based on time filter
    func fetchTransactions(){
        guard let start = timeFilter.date.start, let end = timeFilter.date.end, let predicate = NSPredicate.transactionPredicate(startDate: start, endDate: end, accountId: activeAccountId) else { return }
        let request = TransactionEntity.fetchRequest(for: predicate)
        transactionStore.fetch(request)
    }
    
    // update stat data property
    private func startSubsTransaction(){
        transactionStore.resources
            .receive(on: DispatchQueue.main)
            .sink { transactions in
                self.statsData = .init(transactions)
            }
            .store(in: cancelBag)
    }
    
    
    // whenever there is change in time filter, we trigger fetch transaction & redo the stat data
    private func startDateSubsTransaction(){
        $timeFilter
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { filter in
                self.fetchTransactions()
                self.savedTimeFilter = filter.title
            }
            .store(in: cancelBag)
    }
    
    private func setTimeFilter(){
        timeFilter = TransactionTimeFilter.allCases.first(where: {$0.title == savedTimeFilter}) ?? .day
    }
}

extension RootViewModel{
    
    
    func changeAccount(_ accountId: String){
        activeAccountId = accountId
        fetchAccount()
        fetchTransactions()
    }
    
    func fetchAccount(){
        let request = AccountEntity.request(for: activeAccountId)
       accountStore.fetch(request)
    }
        
    // if change to active account, update active account property or if account array is empty then we set boolean as true whihc will show teh create account page
    private func startSubsAccount(){
        accountStore.resources
            .dropFirst()
            .sink { accounts in
                if let account = accounts.first{
                    self.activeAccount = account
                }else{
                    self.showCreateAccoutView = true
                }
                
            }
            .store(in: cancelBag)
    }
}
