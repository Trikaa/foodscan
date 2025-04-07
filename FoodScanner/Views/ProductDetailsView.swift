import SwiftUI

struct ProductDetailsView: View {
    let product: ProductDetailsModel

    // Пример списков для подсветки
    let badIngredients = ["sugar", "salt", "palm oil", "fructose", "glucose", "preservative", "flavoring"]
    let goodIngredients = ["water", "rice", "oat", "wheat", "corn", "fruit"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(product.productName)
                    .font(.largeTitle)
                    .bold()

                Text("Brand: \(product.brand)")
                    .font(.title3)
                    .foregroundColor(.gray)

                // Nutri-Score
                Text("Nutri-Score")
                    .font(.headline)
                NutriScoreView(nutriScore: product.nutriScore)

                // NOVA Group
                Text("NOVA Group")
                    .font(.headline)
                NovaGroupView(novaGroup: product.novaGroup)

                Divider()

                // Ингредиенты
                Text("Ingredients")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 5) {
                    ForEach(product.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .foregroundColor(colorForIngredient(ingredient))
                    }
                }

                Divider()

                // Пищевая ценность
                Text("Nutritional Information (per 100g)")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Energy: \(product.energy) kcal")
                    Text("Proteins: \(String(format: "%.1f", product.proteins)) g")
                    Text("Fats: \(String(format: "%.1f", product.fats)) g")
                    Text("Carbohydrates: \(String(format: "%.1f", product.carbohydrates)) g")
                    Text("Sugars: \(String(format: "%.1f", product.sugars)) g")
                    Text("Salt: \(String(format: "%.1f", product.salt)) g")
                }

                Divider()

                Text("Scanned on: \(formatDate(product.scannedDate))")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Product Details")
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
