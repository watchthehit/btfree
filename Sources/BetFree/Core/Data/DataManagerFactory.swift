import Foundation

@MainActor
public enum DataManagerFactory {
    public static func createDataManager() -> BetFreeDataManager {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            // Running in tests
            return MockCoreDataManager.shared
        }
        #endif
        return CoreDataManager()
    }
} 