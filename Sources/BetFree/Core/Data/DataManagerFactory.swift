import Foundation
import CoreData
import BetFreeModels

@MainActor
public class DataManagerFactory {
    public static func createDataManager() -> BetFreeDataManager {
        #if DEBUG
        if CommandLine.arguments.contains("--uitesting") {
            return MockCDManager()
        }
        #endif
        
        return CoreDataManager.shared
    }
}