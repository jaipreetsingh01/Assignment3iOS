//
//  UserEntity.swift
//  Finances Helper
//
//  Created by Lance  on 10/05/24.
//

import Foundation
import CoreData

// Extension of UserEntity to add utility methods
extension UserEntity{
    
    // Static method to create a new UserEntity instance
    static func create(name: String, context: NSManagedObjectContext) -> UserEntity{
        let user = UserEntity(context: context) // Creates a new UserEntity instance within the given Core Data context
        user.id = UUID().uuidString // Assigns a unique identifier to the user
        user.name = name // Sets the user's name
        
        return user // Returns the newly created user entity
    }

    // Static method to fetch a UserEntity by its unique identifier
    static func request(for id: String) -> NSFetchRequest<UserEntity>{
        let fetchRequest = NSFetchRequest<UserEntity>(entityName: "UserEntity") // Creates a fetch request for UserEntity
        fetchRequest.predicate = NSPredicate(format: "id == %@", id) // Sets a predicate to filter results by the user ID
        fetchRequest.fetchLimit = 1 // Limits the fetch to only one result
        fetchRequest.propertiesToFetch = ["id", "name"] // Specifies which properties to fetch to optimize performance
        
        return fetchRequest // Returns the configured fetch request
    }
    
}
