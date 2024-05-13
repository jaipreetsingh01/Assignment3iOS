import Foundation
import CoreData

struct CoreDataManager {
    
    //let groupStorage: GroupStorage
    let mainContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext) {
        self.mainContext = mainContext
       //self.groupStorage = GroupStorage(context: mainContext)
    }
    
}

extension CoreDataManager{
    
    
    func updateAccount(account: AccountEntity){
        AccountEntity.updateAccount(for: account)
    }
    
    func createAccount(title: String, currencyCode: String, color: String, balance: Double, members: Set<UserEntity>) -> AccountEntity{
        AccountEntity.create(title: title, currencyCode: currencyCode, balance: balance, color: color, members: members, context: mainContext)
    }

}


extension CoreDataManager{
    
    private func createUserDefault() -> UserEntity{
        let user = UserEntity(context: mainContext)
        user.id = UUID().uuidString
        user.name = "Admin"
        mainContext.saveContext()
        return user
    }
    
    func getCurrentUser(id: String) -> UserEntity{
        let request = UserEntity.request(for: id)
        do {
            let result = try mainContext.fetch(request)
            if let user = result.first {
                return user
            }
        } catch {
            print(error.localizedDescription)
        }
        return createUserDefault()
    }
}

extension NSManagedObjectContext {
    
    func saveContext (){
        if self.hasChanges {
            do{
                try self.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}



