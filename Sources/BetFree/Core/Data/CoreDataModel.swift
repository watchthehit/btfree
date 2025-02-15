import CoreData

enum CoreDataModel {
    static let model: NSManagedObjectModel = {
        return createModel()
    }()
    
    static let schema: NSPersistentStoreDescription = {
        let schema = NSPersistentStoreDescription()
        schema.type = NSSQLiteStoreType
        schema.configuration = "Default"
        return schema
    }()
    
    static func createModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        // Transaction Entity
        let transactionEntity = NSEntityDescription()
        transactionEntity.name = "TransactionEntity"
        transactionEntity.managedObjectClassName = "TransactionEntity"
        
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.type = .uuid
        idAttribute.isOptional = false
        
        let amountAttribute = NSAttributeDescription()
        amountAttribute.name = "amount"
        amountAttribute.type = .double
        amountAttribute.isOptional = false
        
        let dateAttribute = NSAttributeDescription()
        dateAttribute.name = "date"
        dateAttribute.type = .date
        dateAttribute.isOptional = false
        
        let categoryAttribute = NSAttributeDescription()
        categoryAttribute.name = "category"
        categoryAttribute.type = .string
        categoryAttribute.isOptional = false
        
        let noteAttribute = NSAttributeDescription()
        noteAttribute.name = "note"
        noteAttribute.type = .string
        noteAttribute.isOptional = true
        
        transactionEntity.properties = [
            idAttribute,
            amountAttribute,
            dateAttribute,
            categoryAttribute,
            noteAttribute
        ]
        
        // User Profile Entity
        let userProfileEntity = NSEntityDescription()
        userProfileEntity.name = "UserProfileEntity"
        userProfileEntity.managedObjectClassName = "UserProfileEntity"
        
        let userIdAttribute = NSAttributeDescription()
        userIdAttribute.name = "id"
        userIdAttribute.type = .uuid
        userIdAttribute.isOptional = false
        
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.type = .string
        nameAttribute.isOptional = false
        
        let emailAttribute = NSAttributeDescription()
        emailAttribute.name = "email"
        emailAttribute.type = .string
        emailAttribute.isOptional = true
        
        let streakAttribute = NSAttributeDescription()
        streakAttribute.name = "streak"
        streakAttribute.type = .integer32
        streakAttribute.isOptional = false
        
        let totalSavingsAttribute = NSAttributeDescription()
        totalSavingsAttribute.name = "totalSavings"
        totalSavingsAttribute.type = .double
        totalSavingsAttribute.isOptional = false
        
        let dailyLimitAttribute = NSAttributeDescription()
        dailyLimitAttribute.name = "dailyLimit"
        dailyLimitAttribute.type = .double
        dailyLimitAttribute.isOptional = false
        
        let lastCheckInAttribute = NSAttributeDescription()
        lastCheckInAttribute.name = "lastCheckIn"
        lastCheckInAttribute.type = .date
        lastCheckInAttribute.isOptional = true
        
        userProfileEntity.properties = [
            userIdAttribute,
            nameAttribute,
            emailAttribute,
            streakAttribute,
            totalSavingsAttribute,
            dailyLimitAttribute,
            lastCheckInAttribute
        ]
        
        model.entities = [transactionEntity, userProfileEntity]
        return model
    }
}
