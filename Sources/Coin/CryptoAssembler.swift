import Swinject
import Foundation

public class CryptoAssembler {
    @MainActor public static let shared = CryptoAssembler()
    public let container: Container
    
    public init() {  // Changed from private to public
        container = Container()
        registerDependencies()
    }
    
    private func registerDependencies() {
        container.register(URLSession.self) { _ in URLSession.shared }
        container.register(CryptoService.self) { r in
            CryptoAPIService(session: r.resolve(URLSession.self)!)
        }
        // Register CryptoTracker
        container.register(CryptoTracker.self) { resolver in
            CryptoTracker(service: resolver.resolve(CryptoService.self)!)
        }
    }
    
    public func resolve<T>(_ serviceType: T.Type) -> T {
        return container.resolve(serviceType)!
    }
}