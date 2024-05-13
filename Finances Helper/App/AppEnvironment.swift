import Foundation
import Combine
import UserNotifications
import UIKit

final class AppEnvironment: ObservableObject{
    
    let rootVM: RootViewModel
    private var cancelBag = CancelBag()
    init(rootVM: RootViewModel = .init(context: PersistenceController.shared.viewContext)){
        self.rootVM = rootVM


    }
    
        
}
