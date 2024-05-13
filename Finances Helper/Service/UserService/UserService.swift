//
//  UserService.swift
//  Finances Helper
//
//  Created by Lance  on 10/05/24.
//


import Foundation
import SwiftUI
import CoreData

// Declare UserService as a final class and an observable object to be used with SwiftUI views
final class UserService: ObservableObject{

    @AppStorage("currentUserId") private var currentUserId: String = "" // Use of AppStorage to persist the current user's ID across app launches
    @Published var currentUser: UserEntity? // Use of Published to make currentUser a published property, allowing views to update when it changes
    let coreDataManager: CoreDataManager // A reference to CoreDataManager which is to handle all core data interactions
    
    // Initialize the UserService with a NSManagedObjectContext
    init(context: NSManagedObjectContext){
        self.coreDataManager = CoreDataManager(mainContext: context)
        fetchUser() // Fetch the current user on initialization
    }
    
    // Method to fetch the current user from the Core Data
    func fetchUser(){
        currentUser = coreDataManager.getCurrentUser(id: currentUserId) // Fetch the user with the currentUserId and update currentUser
        currentUserId = currentUser?.id ?? "" // Update the currentUserId in case it has changed
    }
}
