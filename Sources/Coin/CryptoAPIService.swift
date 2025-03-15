import Foundation

public class CryptoAPIService: CryptoService {
    private let baseURL = "https://api.coingecko.com/api/v3/coins/markets"
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetchCryptocurrencies() async throws -> [Cryptocurrency] {
        let urlString = "\(baseURL)?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)

        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([Cryptocurrency].self, from: data)
    }
}