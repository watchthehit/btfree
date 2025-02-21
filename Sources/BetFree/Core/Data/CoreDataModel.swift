import Foundation
import CoreData
import BetFreeModels

public final class CoreDataModel {
    public static let shared = CoreDataModel()
    
    private init() {}
    
    public func createModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        // User Profile Entity
        let userEntity = NSEntityDescription()
        userEntity.name = "UserProfileEntity"
        userEntity.managedObjectClassName = NSStringFromClass(UserProfileEntity.self)
        
        let idStringAttribute = NSAttributeDescription()
        idStringAttribute.name = "idString"
        idStringAttribute.attributeType = .stringAttributeType
        idStringAttribute.isOptional = false
        
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.attributeType = .stringAttributeType
        nameAttribute.isOptional = false
        nameAttribute.defaultValue = ""
        
        let emailAttribute = NSAttributeDescription()
        emailAttribute.name = "email"
        emailAttribute.attributeType = .stringAttributeType
        emailAttribute.isOptional = true
        
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
            idStringAttribute,
            nameAttribute,
            emailAttribute,
            dailyLimitAttribute,
            streakAttribute,
            lastCheckInAttribute,
            totalSavingsAttribute
        ]
        
        // Transaction Entity
        let transactionEntity = NSEntityDescription()
        transactionEntity.name = "TransactionEntity"
        transactionEntity.managedObjectClassName = NSStringFromClass(TransactionEntity.self)
        
        let transactionIdStringAttribute = NSAttributeDescription()
        transactionIdStringAttribute.name = "idString"
        transactionIdStringAttribute.attributeType = .stringAttributeType
        transactionIdStringAttribute.isOptional = false
        
        let amountAttribute = NSAttributeDescription()
        amountAttribute.name = "amount"
        amountAttribute.attributeType = .doubleAttributeType
        amountAttribute.isOptional = false
        amountAttribute.defaultValue = 0.0
        
        let categoryAttribute = NSAttributeDescription()
        categoryAttribute.name = "category"
        categoryAttribute.attributeType = .stringAttributeType
        categoryAttribute.isOptional = false
        categoryAttribute.defaultValue = TransactionCategory.other.rawValue
        
        let dateAttribute = NSAttributeDescription()
        dateAttribute.name = "date"
        dateAttribute.attributeType = .dateAttributeType
        dateAttribute.isOptional = false
        dateAttribute.defaultValue = Date()
        
        let noteAttribute = NSAttributeDescription()
        noteAttribute.name = "note"
        noteAttribute.attributeType = .stringAttributeType
        noteAttribute.isOptional = true
        
        transactionEntity.properties = [
            transactionIdStringAttribute,
            amountAttribute,
            categoryAttribute,
            dateAttribute,
            noteAttribute
        ]
        
        // Craving Entity
        let cravingEntity = NSEntityDescription()
        cravingEntity.name = "CravingEntity"
        cravingEntity.managedObjectClassName = NSStringFromClass(CravingEntity.self)
        
        let cravingIdAttribute = NSAttributeDescription()
        cravingIdAttribute.name = "id"
        cravingIdAttribute.attributeType = .UUIDAttributeType
        cravingIdAttribute.isOptional = false
        
        let intensityAttribute = NSAttributeDescription()
        intensityAttribute.name = "intensity"
        intensityAttribute.attributeType = .integer16AttributeType
        intensityAttribute.isOptional = false
        intensityAttribute.defaultValue = 0
        
        let triggerAttribute = NSAttributeDescription()
        triggerAttribute.name = "trigger"
        triggerAttribute.attributeType = .stringAttributeType
        triggerAttribute.isOptional = true
        
        let locationAttribute = NSAttributeDescription()
        locationAttribute.name = "location"
        locationAttribute.attributeType = .stringAttributeType
        locationAttribute.isOptional = true
        
        let durationAttribute = NSAttributeDescription()
        durationAttribute.name = "duration"
        durationAttribute.attributeType = .integer32AttributeType
        durationAttribute.isOptional = false
        durationAttribute.defaultValue = 0
        
        let cravingNoteAttribute = NSAttributeDescription()
        cravingNoteAttribute.name = "note"
        cravingNoteAttribute.attributeType = .stringAttributeType
        cravingNoteAttribute.isOptional = true
        
        let cravingDateAttribute = NSAttributeDescription()
        cravingDateAttribute.name = "date"
        cravingDateAttribute.attributeType = .dateAttributeType
        cravingDateAttribute.isOptional = false
        cravingDateAttribute.defaultValue = Date()
        
        cravingEntity.properties = [
            cravingIdAttribute,
            intensityAttribute,
            triggerAttribute,
            locationAttribute,
            durationAttribute,
            cravingNoteAttribute,
            cravingDateAttribute
        ]
        
        model.entities = [userEntity, transactionEntity, cravingEntity]
        return model
    }
}
