import CoreData
import Foundation

public enum CoreDataModel {
    @MainActor
    public static func createModel() -> NSManagedObjectModel {
        createModelSync()
    }
    
    static func createModelSync() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        // User Profile Entity
        let userEntity = NSEntityDescription()
        userEntity.name = "BetFree_UserProfile"
        userEntity.managedObjectClassName = "BetFree.UserProfile"
        
        let userIdAttribute = NSAttributeDescription()
        userIdAttribute.name = "id"
        userIdAttribute.attributeType = .UUIDAttributeType
        userIdAttribute.isOptional = false
        userIdAttribute.defaultValue = UUID()
        
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.attributeType = .stringAttributeType
        nameAttribute.isOptional = true
        nameAttribute.defaultValue = ""
        
        let emailAttribute = NSAttributeDescription()
        emailAttribute.name = "email"
        emailAttribute.attributeType = .stringAttributeType
        emailAttribute.isOptional = true
        emailAttribute.defaultValue = ""
        
        let dailyLimitAttribute = NSAttributeDescription()
        dailyLimitAttribute.name = "dailyLimit"
        dailyLimitAttribute.attributeType = .doubleAttributeType
        dailyLimitAttribute.isOptional = false
        dailyLimitAttribute.defaultValue = 0.0
        
        let streakAttribute = NSAttributeDescription()
        streakAttribute.name = "streak"
        streakAttribute.attributeType = .integer32AttributeType
        streakAttribute.isOptional = false
        streakAttribute.defaultValue = 0
        
        let lastCheckInAttribute = NSAttributeDescription()
        lastCheckInAttribute.name = "lastCheckIn"
        lastCheckInAttribute.attributeType = .dateAttributeType
        lastCheckInAttribute.isOptional = true
        
        let totalSavingsAttribute = NSAttributeDescription()
        totalSavingsAttribute.name = "totalSavings"
        totalSavingsAttribute.attributeType = .doubleAttributeType
        totalSavingsAttribute.isOptional = false
        totalSavingsAttribute.defaultValue = 0.0
        
        userEntity.properties = [
            userIdAttribute,
            nameAttribute,
            emailAttribute,
            dailyLimitAttribute,
            streakAttribute,
            lastCheckInAttribute,
            totalSavingsAttribute
        ]
        
        // Transaction Entity
        let transactionEntity = NSEntityDescription()
        transactionEntity.name = "Transaction"
        transactionEntity.managedObjectClassName = "BetFree.Transaction"
        
        let transactionIdAttribute = NSAttributeDescription()
        transactionIdAttribute.name = "id"
        transactionIdAttribute.attributeType = .UUIDAttributeType
        transactionIdAttribute.isOptional = false
        transactionIdAttribute.defaultValue = UUID()
        
        let amountAttribute = NSAttributeDescription()
        amountAttribute.name = "amount"
        amountAttribute.attributeType = .doubleAttributeType
        amountAttribute.isOptional = false
        amountAttribute.defaultValue = 0.0
        
        let dateAttribute = NSAttributeDescription()
        dateAttribute.name = "date"
        dateAttribute.attributeType = .dateAttributeType
        dateAttribute.isOptional = false
        dateAttribute.defaultValue = Date()
        
        let noteAttribute = NSAttributeDescription()
        noteAttribute.name = "note"
        noteAttribute.attributeType = .stringAttributeType
        noteAttribute.isOptional = true
        noteAttribute.defaultValue = ""
        
        let categoryAttribute = NSAttributeDescription()
        categoryAttribute.name = "category"
        categoryAttribute.attributeType = .stringAttributeType
        categoryAttribute.isOptional = true
        categoryAttribute.defaultValue = ""
        
        transactionEntity.properties = [
            transactionIdAttribute,
            amountAttribute,
            dateAttribute,
            noteAttribute,
            categoryAttribute
        ]
        
        // Achievement Entity
        let achievementEntity = NSEntityDescription()
        achievementEntity.name = "BetFree_Achievement"
        achievementEntity.managedObjectClassName = "BetFree.BetFree_Achievement"
        
        let achievementIdAttribute = NSAttributeDescription()
        achievementIdAttribute.name = "id"
        achievementIdAttribute.attributeType = .UUIDAttributeType
        achievementIdAttribute.isOptional = false
        achievementIdAttribute.defaultValue = UUID()
        
        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = false
        titleAttribute.defaultValue = ""
        
        let descAttribute = NSAttributeDescription()
        descAttribute.name = "desc"
        descAttribute.attributeType = .stringAttributeType
        descAttribute.isOptional = false
        descAttribute.defaultValue = ""
        
        let iconAttribute = NSAttributeDescription()
        iconAttribute.name = "icon"
        iconAttribute.attributeType = .stringAttributeType
        iconAttribute.isOptional = false
        iconAttribute.defaultValue = ""
        
        let colorHexAttribute = NSAttributeDescription()
        colorHexAttribute.name = "colorHex"
        colorHexAttribute.attributeType = .stringAttributeType
        colorHexAttribute.isOptional = false
        colorHexAttribute.defaultValue = "#007AFF"
        
        let progressAttribute = NSAttributeDescription()
        progressAttribute.name = "progress"
        progressAttribute.attributeType = .doubleAttributeType
        progressAttribute.isOptional = false
        progressAttribute.defaultValue = 0.0
        
        let isUnlockedAttribute = NSAttributeDescription()
        isUnlockedAttribute.name = "isUnlocked"
        isUnlockedAttribute.attributeType = .booleanAttributeType
        isUnlockedAttribute.isOptional = false
        isUnlockedAttribute.defaultValue = false
        
        let unlockDateAttribute = NSAttributeDescription()
        unlockDateAttribute.name = "unlockDate"
        unlockDateAttribute.attributeType = .dateAttributeType
        unlockDateAttribute.isOptional = true
        
        let lastCheckInHourAttribute = NSAttributeDescription()
        lastCheckInHourAttribute.name = "lastCheckInHour"
        lastCheckInHourAttribute.attributeType = .integer16AttributeType
        lastCheckInHourAttribute.isOptional = false
        lastCheckInHourAttribute.defaultValue = -1
        
        achievementEntity.properties = [
            achievementIdAttribute,
            titleAttribute,
            descAttribute,
            iconAttribute,
            colorHexAttribute,
            progressAttribute,
            isUnlockedAttribute,
            unlockDateAttribute,
            lastCheckInHourAttribute
        ]
        
        // Add entities to model
        model.entities = [userEntity, transactionEntity, achievementEntity]
        
        return model
    }
    
    #if DEBUG
    static func resetModel() {
        // No-op since we're not caching anymore
    }
    #endif
} 