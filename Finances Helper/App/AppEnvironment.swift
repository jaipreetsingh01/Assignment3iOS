import Foundation
import Combine
import UserNotifications
import UIKit


// manages the overall environment of the application
final class AppEnvironment: ObservableObject{
    
    // root view model controls application's logic.
    let rootVM: RootViewModel
    
    // we have @published variables, cancellable - so cancel hag is to prevent memory leaks
    private var cancelBag = CancelBag()
    init(rootVM: RootViewModel = .init(context: PersistenceController.shared.viewContext)){
        self.rootVM = rootVM
    }
    
        
}

