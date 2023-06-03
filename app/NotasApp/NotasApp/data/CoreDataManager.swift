//
//  CoreDataManager.swift
//  NotasApp
//
//  Created by Jose on 2/06/23.
//

import Foundation
import CoreData


class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "DataModel")
    
    let persistentContainer : NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    init(modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil){
        persistentContainer.loadPersistentStores {
            (info, error) in
            
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func save() {
            if viewContext.hasChanges {
                do {
                    try viewContext.save()
                } catch {
                    print("An error ocurred while saving: \(error.localizedDescription)")
                }
            }
    }
}

protocol CoreDataCRUD{
    associatedtype T
    associatedtype E
    func saveData(data: T)
    func allData() -> [E]
    func deleteData(uuid: String)
    func updateData(data: T)
}


extension CoreDataManager : CoreDataCRUD {
    
    func deleteData(uuid: String) {
        <#code#>
    }
    
    func saveData(data: CuentaInsertDTO) {
        let cuenta = Cuenta(context: viewContext)
        cuenta.id = UUID()
        cuenta.username = data.username
        cuenta.password = data.password
        save()
    }
    
    func allData() -> [CuentaDTO] {
        let fetchListRequest: NSFetchRequest<Cuenta> = Cuenta.fetchRequest()
                var lists = [Cuenta]()
                do {
                    lists = try viewContext.fetch(fetchListRequest)
                } catch {
                    print(error.localizedDescription)
                }
        return lists.map{e in CuentaDTO.mapToDTO(cuenta: e)}
    }
    
    func updateData(data: CuentaInsertDTO) {
        <#code#>
    }
    

    
    
    typealias T = CuentaInsertDTO
    typealias E = CuentaDTO
    
    func createAccount() -> Cuenta {
        let cuenta = Cuenta(context: viewContext)
        cuenta.id = UUID()
        cuenta.username = ""
        cuenta.password = ""
        save()
        return cuenta
    }
    
    func fetchAccounts(filter: String? = nil) -> [Cuenta] {
        let request: NSFetchRequest<Cuenta> = Cuenta.fetchRequest()
        
        if let filter = filter {
            let predicate = NSPredicate(format: "username contains[cd] %@", filter)
            request.predicate = predicate
        }
        
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func deleteAccount(_ cuenta: Cuenta) {
        viewContext.delete(cuenta)
        save()
    }
    
    
    private func searchTodo(uuid: String, completion: @escaping(Cuenta) -> Void ) {
            let fetchListRequest: NSFetchRequest<Cuenta> = Cuenta.fetchRequest()
            let predicate: NSPredicate = NSPredicate(format: "id == %@", uuid)
            fetchListRequest.predicate = predicate
            
            do {
                let objects = try viewContext.fetch(fetchListRequest)
                guard let cuenta = objects.first else { return }
                completion(cuenta)
            } catch {
                print(error.localizedDescription)
            }
        }
}
