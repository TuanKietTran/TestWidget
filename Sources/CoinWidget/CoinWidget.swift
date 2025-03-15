import WidgetKit
import SwiftUI
import Coin

struct CryptoProvider: TimelineProvider {
    public let cryptoTracker: CryptoTracker
    
    init() {
        let assembler = CryptoAssembler()
        self.cryptoTracker = assembler.resolve(CryptoTracker.self)
    }
    
    func placeholder(in context: Context) -> CryptoEntry {
        CryptoEntry(
            date: Date(),
            cryptocurrency: Cryptocurrency(
                id: "bitcoin",
                name: "Bitcoin",
                symbol: "BTC",
                currentPrice: 50000.0,
                marketCap: 1000000000.0
            )
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CryptoEntry) -> Void) {
        let entry = CryptoEntry(
            date: Date(),
            cryptocurrency: Cryptocurrency(
                id: "bitcoin",
                name: "Bitcoin",
                symbol: "BTC",
                currentPrice: 50000.0,
                marketCap: 1000000000.0
            )
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<CryptoEntry>) -> Void) {
        Task {
            do {
                let cryptocurrencies = try await cryptoTracker.getCryptocurrencies()
                let bitcoin = cryptocurrencies.first { $0.id == "bitcoin" } ?? cryptocurrencies[0]
                
                let entry = CryptoEntry(date: Date(), cryptocurrency: bitcoin)
                
                // Refresh every hour
                let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("Failed to fetch cryptocurrencies: \(error)")
                // Fallback in case of error
                let entry = CryptoEntry(
                    date: Date(),
                    cryptocurrency: Cryptocurrency(
                        id: "error",
                        name: "Error",
                        symbol: "ERR",
                        currentPrice: 0.0,
                        marketCap: 0.0
                    )
                )
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct CryptoEntry: TimelineEntry {
    let date: Date
    let cryptocurrency: Cryptocurrency
}

struct CoinWidgetEntryView: View {
    var entry: CryptoProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.cryptocurrency.name)
                .font(.headline)
            Text(entry.cryptocurrency.symbol)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text("$\(String(format: "%.2f", entry.cryptocurrency.currentPrice))")
                .font(.title2)
                .bold()
            Text("MCap: $\(String(format: "%.0f", entry.cryptocurrency.marketCap))")
                .font(.caption)
        }
        .padding()
    }
}

struct CoinWidget: Widget {
    let kind: String = "CoinWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CryptoProvider()) { entry in
            CoinWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Crypto Price")
        .description("Shows the current price of Bitcoin")
        .supportedFamilies([.systemSmall])
    }
}

// Preview provider
struct CoinWidget_Previews: PreviewProvider {
    static var previews: some View {
        CoinWidgetEntryView(
            entry: CryptoEntry(
                date: Date(),
                cryptocurrency: Cryptocurrency(
                    id: "bitcoin",
                    name: "Bitcoin",
                    symbol: "BTC",
                    currentPrice: 50000.0,
                    marketCap: 1000000000.0
                )
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}