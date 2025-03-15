import Testing
import Swinject
@testable import Coin

@MainActor
struct CryptoTests {
    let assembler = CryptoAssembler.shared
    
    @Test
    @MainActor
    func testFetchCryptocurrencies() async throws {
        let tracker = assembler.resolve(CryptoTracker.self)
        let cryptocurrencies = try await tracker.getCryptocurrencies()
        
        #expect(!cryptocurrencies.isEmpty, "Cryptocurrency list should not be empty")
        #expect(cryptocurrencies.contains { $0.id == "bitcoin" }, "Bitcoin should be in the list")
    }
    
    @Test
    @MainActor
    func testFetchCryptocurrenciesWithMock() async throws {
        class MockCryptoService: CryptoService {
            func fetchCryptocurrencies() async throws -> [Cryptocurrency] {
                return [
                    Cryptocurrency(
                        id: "bitcoin",
                        name: "Bitcoin",
                        symbol: "BTC",
                        currentPrice: 50000.0,
                        marketCap: 1000000000.0
                    )
                ]
            }
        }
        
        assembler.container.removeAll()
        assembler.container.register(CryptoService.self) { _ in MockCryptoService() }
        assembler.container.register(CryptoTracker.self) { r in
            CryptoTracker(service: r.resolve(CryptoService.self)!)
        }
        
        let tracker = assembler.resolve(CryptoTracker.self)
        let cryptocurrencies = try await tracker.getCryptocurrencies()
        
        #expect(cryptocurrencies.count == 1, "Should return exactly one cryptocurrency")
        #expect(cryptocurrencies.first?.id == "bitcoin", "Should return bitcoin")
    }
}