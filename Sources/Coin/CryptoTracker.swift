public struct CryptoTracker: @unchecked Sendable {
    private let service: CryptoService
    
    public init(service: CryptoService = CryptoAPIService()) {
        self.service = service
    }
    
    public func getCryptocurrencies() async throws -> [Cryptocurrency] {
        return try await service.fetchCryptocurrencies()
    }
}