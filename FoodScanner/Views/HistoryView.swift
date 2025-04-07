import SwiftUI

struct HistoryView: View {
    @State private var history: [ProductDetailsModel] = []
    @State private var selectedFilter = "All"
    private let filters = ["All", "A", "B", "C", "D", "E"]

    var body: some View {
        NavigationView {
            VStack {
                FilterBarView(selectedFilter: $selectedFilter)

                List(filteredHistory, id: \.productName) { product in
                    NavigationLink(destination: ProductDetailsView(product: product)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.productName)
                                .font(.headline)

                            Text("\("brand".localized): \(product.brand)")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            HStack {
                                Text("nutri_score".localized)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(product.nutriScore.uppercased())
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(colorForNutriScore(product.nutriScore))
                            }

                            Text("\("scanned_on".localized) \(formattedDate(product.scannedDate))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 6)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("scan_history".localized)
            }
            .onAppear(perform: loadHistory)
        }
    }

    var filteredHistory: [ProductDetailsModel] {
        if selectedFilter == "All" {
            return history
        } else {
            return history.filter { $0.nutriScore.uppercased() == selectedFilter }
        }
    }

    func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: "history"),
           let decoded = try? JSONDecoder().decode([ProductDetailsModel].self, from: data) {
            history = decoded
        }
    }

    func colorForNutriScore(_ score: String) -> Color {
        switch score.uppercased() {
        case "A": return .green
        case "B": return .green.opacity(0.7)
        case "C": return .yellow
        case "D": return .orange
        case "E": return .red
        default: return .gray
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct FilterBarView: View {
    @Binding var selectedFilter: String
    let filters = ["All", "A", "B", "C", "D", "E"]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filters, id: \.self) { filter in
                    Button(action: {
                        selectedFilter = filter
                    }) {
                        Text(filter == "All" ? filter.localized : filter)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(selectedFilter == filter ? Color.gray.opacity(0.3) : Color.clear)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                    .foregroundColor(selectedFilter == filter ? .white : .blue)
                }
            }
            .padding(.horizontal)
        }
    }
}
