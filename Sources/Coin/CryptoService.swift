public protocol CryptoService {
    func fetchCryptocurrencies() async throws -> [Cryptocurrency]
}