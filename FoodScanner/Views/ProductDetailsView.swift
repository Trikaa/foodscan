import SwiftUI

struct ProductDetailsView: View {
    let product: ProductDetailsModel

    let badIngredients = ["sugar", "salt", "palm oil", "fructose", "glucose", "preservative", "flavoring"]
    let goodIngredients = ["water", "rice", "oat", "wheat", "corn", "fruit"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(product.productName)
                    .font(.largeTitle)
                    .bold()

                Text("\("brand".localized): \(product.brand)")
                    .font(.title3)
                    .foregroundColor(.gray)

                // Nutri-Score
                Text("nutri_score".localized)
                    .font(.headline)
                NutriScoreView(nutriScore: product.nutriScore)

                // NOVA Group
                Text("nova_group".localized)
                    .font(.headline)
                NovaGroupView(novaGroup: product.novaGroup)

                Divider()

                // Ингредиенты
                Text("ingredients".localized)
                    .font(.headline)

                VStack(alignment: .leading, spacing: 5) {
                    ForEach(product.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .foregroundColor(colorForIngredient(ingredient))
                    }
                }

                Divider()

                // Пищевая ценность
                Text("nutritional_info".localized)
                    .font(.headline)

                VStack(alignment: .leading, spacing: 5) {
                    Text("\("energy".localized): \(product.energy) kcal")
                    Text("\("proteins".localized): \(String(format: "%.1f", product.proteins)) g")
                    Text("\("fats".localized): \(String(format: "%.1f", product.fats)) g")
                    Text("\("carbohydrates".localized): \(String(format: "%.1f", product.carbohydrates)) g")
                    Text("\("sugars".localized): \(String(format: "%.1f", product.sugars)) g")
                    Text("\("salt".localized): \(String(format: "%.1f", product.salt)) g")
                }

                Divider()

                Text("\("scanned_on".localized) \(formatDate(product.scannedDate))")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("product_details".localized)
        .navigationBarTitleDisplayMode(.inline)
    }

    func colorForIngredient(_ ingredient: String) -> Color {
        let lowerIngredient = ingredient.lowercased()
        if badIngredients.contains(where: { lowerIngredient.contains($0) }) {
            return .red
        } else if goodIngredients.contains(where: { lowerIngredient.contains($0) }) {
            return .green
        } else {
            return .primary
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
