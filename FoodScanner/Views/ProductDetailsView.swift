import SwiftUI

struct ProductDetailsView: View {
    let product: ProductDetailsModel
    @State private var ingredientStatuses: [String: IngredientStatus] = [:]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Название продукта (Оригинал или Unknown Product локализованный)
                Text(product.productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "unknown_product".localized : product.productName)
                    .font(.largeTitle)
                    .bold()

                // Бренд (Оригинал или Unknown Brand локализованный)
                Text("brand".localized + ": " + (product.brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "unknown_brand".localized : product.brand))
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

                if product.ingredients.isEmpty {
                    Text("no_ingredients".localized)
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(product.ingredients, id: \.self) { ingredient in
                            Text(ingredient.localized) // ✅ Ингредиенты локализируем
                                .foregroundColor(colorForIngredient(ingredient))
                        }
                    }
                }

                Divider()

                // Нутриенты
                Text("nutritional_info".localized)
                    .font(.headline)

                if isNutritionalInfoAvailable {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\("energy".localized): \(product.energy) kcal")
                        Text("\("proteins".localized): \(String(format: "%.1f", product.proteins)) g")
                        Text("\("fats".localized): \(String(format: "%.1f", product.fats)) g")
                        Text("\("carbohydrates".localized): \(String(format: "%.1f", product.carbohydrates)) g")
                        Text("\("sugars".localized): \(String(format: "%.1f", product.sugars)) g")
                        Text("\("salt".localized): \(String(format: "%.1f", product.salt)) g")
                    }
                } else {
                    Text("no_nutritional_info".localized)
                        .foregroundColor(.gray)
                        .italic()
                }

                Divider()

                // Источник базы
                if !product.source.isEmpty {
                    Text("\("source".localized): \(product.source)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                // Дата сканирования
                Text("\("scanned_on".localized): \(formatDate(product.scannedDate))")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("product_details".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchStatuses()
        }
    }

    var isNutritionalInfoAvailable: Bool {
        let nonZeroValues = [
            Double(product.energy),
            product.proteins,
            product.fats,
            product.carbohydrates,
            product.sugars,
            product.salt
        ].filter { $0 > 0 }

        return !nonZeroValues.isEmpty
    }

    func fetchStatuses() {
        IngredientStatusService.shared.fetchIngredientStatus(for: product.ingredients) { statuses in
            self.ingredientStatuses = statuses
        }
    }

    func colorForIngredient(_ ingredient: String) -> Color {
        switch ingredientStatuses[ingredient.lowercased()] {
        case .bad:
            return .red
        case .good:
            return .green
        case .unknown, .none:
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
