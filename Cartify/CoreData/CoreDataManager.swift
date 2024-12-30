//
//  CoreDataManager.swift
//  Cartify
//
//  Created by Mustafa on 27.12.2024.
//
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cartify")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    /// For favorite handing
    func saveFavorite(product: ProductElement) {
        let context = CoreDataManager.shared.context
        let addedToCart = CoreDataProduct(context: context)
        addedToCart.image = product.image
        print(product.image)
        addedToCart.desc = product.description
        addedToCart.brand = product.brand
        addedToCart.model = product.model
        addedToCart.name = product.name
        addedToCart.price = product.price
        addedToCart.id = product.id
        
        CoreDataManager.shared.saveContext()
    }
    
    func removeFavorite(productId: String) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<CoreDataProduct> = CoreDataProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        do {
            if let result = try context.fetch(fetchRequest).first {
                context.delete(result)
                saveContext()
            }
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }
    
    func fetchAllFavorites() -> [CoreDataProduct] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoreDataProduct> = CoreDataProduct.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch all cart products: \(error)")
            return []
        }
    }
    
    func isFavorite(productId: String) -> Bool {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<CoreDataProduct> = CoreDataProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        
        return (try? context.count(for: fetchRequest)) ?? 0 > 0
    }
    
    
    /// Cart functions
    func saveToCart(product: ProductElement, quantity: Int) {
        let context = persistentContainer.viewContext
        
        let coreDataProduct = CoreDataCartProduct(context: context)
        coreDataProduct.id = product.id
        coreDataProduct.name = product.name
        coreDataProduct.price = product.price
        coreDataProduct.quantity = Int32(quantity)
        
        do {
            try context.save()
        } catch {
            print("Failed to save product to cart: \(error)")
        }
    }
    
    func fetchAllCartProducts() -> [CoreDataCartProduct] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoreDataCartProduct> = CoreDataCartProduct.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch all cart products: \(error)")
            return []
        }
    }
    
    func isProductInCart(productId: String) -> Bool {
        let fetchRequest: NSFetchRequest<CoreDataCartProduct> = CoreDataCartProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Error checking product in cart: \(error)")
            return false
        }
    }
    
    func incrementProductQuantity(productId: String) {
        let fetchRequest: NSFetchRequest<CoreDataCartProduct> = CoreDataCartProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        do {
            if let product = try context.fetch(fetchRequest).first {
                product.quantity += 1
                saveContext()
            }
        } catch {
            print("Error incrementing product quantity: \(error)")
        }
    }
    
    func delete(_ product: CoreDataCartProduct) {
        context.delete(product)
        saveContext()
    }
    
    func getCartItemCount() -> Int {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoreDataCartProduct> = CoreDataCartProduct.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest).count
        } catch {
            print("Failed to fetch all cart products: \(error)")
            return 0
        }
    }
}
