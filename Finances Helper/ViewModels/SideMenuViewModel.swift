//
//  SideMenuViewModel.swift
//  Finances Helper
//
//  Created by Jaipreet  on 10/05/24.
//

import Foundation
import CoreData
import Combine

final class SideMenuViewModel: ObservableObject{
    
    @Published var user: UserEntity?
    
    private var cancelBag = CancelBag()
    let userService: UserService
    
    init(context: NSManagedObjectContext){
        self.userService = UserService(context: context)
    }
    

    
}
