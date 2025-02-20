import Foundation
import BetFreeCore

@MainActor
public protocol ViewDependencies {
    var serviceProvider: ServiceProvider { get }
    var environment: AppEnvironment { get }
}

@MainActor
public struct DefaultViewDependencies: ViewDependencies {
    public let serviceProvider: ServiceProvider
    public let environment: AppEnvironment
    
    public static func shared() async -> DefaultViewDependencies {
        await DefaultViewDependencies(
            serviceProvider: DefaultServiceProvider.shared(),
            environment: .current
        )
    }
    
    public init(
        serviceProvider: ServiceProvider,
        environment: AppEnvironment
    ) {
        self.serviceProvider = serviceProvider
        self.environment = environment
    }
}

@MainActor
public struct MockViewDependencies: ViewDependencies {
    public let serviceProvider: ServiceProvider
    public let environment: AppEnvironment
    
    public static func shared() async -> MockViewDependencies {
        await MockViewDependencies(
            serviceProvider: MockServiceProvider.shared(),
            environment: .testing
        )
    }
    
    public init(
        serviceProvider: ServiceProvider,
        environment: AppEnvironment
    ) {
        self.serviceProvider = serviceProvider
        self.environment = environment
    }
}

extension ViewDependencies {
    public var savingsManager: SavingsManager {
        serviceProvider.savingsManager as! SavingsManager
    }
    
    public var cravingManager: CravingManager {
        serviceProvider.cravingManager as! CravingManager
    }
} 