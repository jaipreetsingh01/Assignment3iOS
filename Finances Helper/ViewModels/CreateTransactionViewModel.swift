// CreateTransactionViewModel.swift
//  Finances Helper
//
//  Created by Kendrick  on 10/05/24.
//

import Foundation
import Combine
import CoreData
import SwiftUI

// ViewModel for creating transactions
class CreateTransactionViewModel: ObservableObject {
    
    // Published properties for transaction details
    @Published var transactionType: TransactionType = .expense
    @Published var note: String = ""
    @Published var amount: Double = 0
    @Published var date: Date = Date.now
    @Published var selectedSubCategoryId: String?
    @Published var selectedCategory: CategoryEntity?
    @Published var categories = [CategoryEntity]()
    
    // Published properties for managing category creation view
    @Published var createCategoryViewType: CreateCategoryViewType?
    @Published var categoryColor: Color = .blue
    @Published var categoryTitle: String = ""
    
    // ResourceStore for managing CategoryEntity resources
    private let categoriesStore: ResourceStore<CategoryEntity>
    private var cancelBag = CancelBag()
    private let context: NSManagedObjectContext
    
    // Initialize CreateTransactionViewModel with a Core Data context and transaction type
    init(context: NSManagedObjectContext, transactionType: TransactionType) {
        self.context = context
        self.transactionType = transactionType
        categoriesStore = ResourceStore(context: context)
        
        startSubsCategories()
        
        fetchCategories()
    }
    
    // Deinitializer
    deinit {
        cancelBag.cancel()
    }
    
    // Computed property to determine if the save button should be disabled
    var disabledSave: Bool {
        amount == 0 || selectedCategory == nil
    }
    
    // Fetch categories from Core Data
    private func fetchCategories() {
        let request = CategoryEntity.request()
        categoriesStore.fetch(request)
    }
    
    // Subscribe to changes in categories
    private func startSubsCategories(){
        categoriesStore.resources
            .sink { categories in
                self.categories = categories
            }
            .store(in: cancelBag)
    }
    
    // Toggle selection of a category
    func toggleSelectCategory(_ category: CategoryEntity) {
        selectedCategory = category.objectID == selectedCategory?.objectID ? nil : category
    }
    
    // Toggle selection of a subcategory
    func toggleSelectSubcategory(_ categoryId: String) {
        selectedSubCategoryId = categoryId == selectedSubCategoryId ? nil : categoryId
    }
    
    // Create a transaction
    func create(type: TransactionType, date: Date, forAccount: AccountEntity?, created: UserEntity?) {
        guard let selectedCategory, let forAccount, let created else { return }
        TransactionEntity.create(amount: amount, createAt: date, type: type, created: created, account: forAccount, category: selectedCategory, subcategoryId: selectedSubCategoryId, note: note, context: context)
    }

    // Add a new category
    func addCategory() {
        let category = CategoryEntity.create(context: context, title: categoryTitle, color: categoryColor.toHex(), subcategories: nil, isParent: true, type: transactionType)
        context.saveContext()
        createCategoryViewType = nil
        categoryTitle = ""
        selectedCategory = category
    }
    
    // Add a new subcategory
    func addSubcategory() {
        if let selectedCategory {
            let subcategory = CategoryEntity.create(context: context, title: categoryTitle, color: categoryColor.toHex(), subcategories: nil, isParent: false, type: transactionType)
            selectedCategory.wrappedSubcategories = [subcategory]
            context.saveContext()
            createCategoryViewType = nil
            categoryTitle = ""
            selectedSubCategoryId = subcategory.id
        }
    }
}
