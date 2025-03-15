import Foundation

public struct Cryptocurrency: Identifiable, Codable, Sendable {
  public let id: String
  public let name: String
  public let symbol: String
  public let currentPrice: Double
  public let marketCap: Double

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case symbol
    case currentPrice = "current_price"
    case marketCap = "market_cap"
  }

    // Add this new initializer
  public init(id: String, name: String, symbol: String, currentPrice: Double, marketCap: Double) {
      self.id = id
      self.name = name
      self.symbol = symbol
      self.currentPrice = currentPrice
      self.marketCap = marketCap
  }
}
