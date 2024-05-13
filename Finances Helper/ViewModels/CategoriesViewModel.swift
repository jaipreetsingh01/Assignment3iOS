// CategoriesViewModel.swift
//  Finances Helper
//
//  Created by Kendrick  on 10/05/24.
//

import Foundation
import CoreData

// ViewModel for managing categories
class CategoriesViewModel: ObservableObject {
    
    // Published property for categories
    @Published private(set) var categories = [CategoryEntity]()
    
    // CancelBag for managing subscriptions
    private var cancelBag = CancelBag()
    
    // Core Data context
    private let context: NSManagedObjectContext
    
    // ResourceStore for managing CategoryEntity resources
    private let categoriesStore: ResourceStore<CategoryEntity>
    
    // Initialize CategoriesViewModel with a Core Data context
    init(context: NSManagedObjectContext) {
        self.context = context
        self.categoriesStore = ResourceStore(context: context)
        
        // Subscribe to categories changes and fetch categories
        subscribeCategories()
        fetchCategories()
    }
    
    // Fetch categories from Core Data
    private func fetchCategories() {
        let request = CategoryEntity.request()
        categoriesStore.fetch(request)
    }
    
    // Subscribe to categories changes
    private func subscribeCategories() {
        categoriesStore.resources
            .sink { [weak self] categories in
                guard let self = self else { return }
                self.categories = categories
            }
            .store(in: cancelBag)
    }
}
