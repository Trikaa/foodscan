import SwiftUI

struct ProductDetailsView: View {
    let product: ProductDetailsModel

    // 🔥 Оригинальные плохие и хорошие ингредиенты (по-английски)
    let badIngredients = ["sugar", "salt", "palm oil", "fructose", "glucose", "preservative", "flavoring"]
    let goodIngredients = ["water", "rice", "oat", "wheat", "corn", "fruit"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // ✅ Название продукта (локализированное)
                Text(product.productName.localized)
                    .font(.largeTitle)
                    .bold()

                // ✅ Бренд (оригинал, без локализации)
                Text("\("brand".localized): \(product.brand)")
                    .font(.title3)
                    .foregroundColor(.gray)

                // ✅ Nutri-Score
                Text("nutri_score".localized)
                    .font(.headline)
                NutriScoreView(nutriScore: product.nutriScore)

                // ✅ NOVA Group
                Text("nova_group".localized)
                    .font(.headline)
                NovaGroupView(novaGroup: product.novaGroup)

                Divider()

                // ✅ Ингредиенты
                Text("ingredients".localized)
                    .font(.headline)

                if product.ingredients.isEmpty {
                    Text("No ingredients information available.".localized)
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(product.ingredients, id: \.self) { ingredient in
                            let trimmedIngredient = ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
                            Text(trimmedIngredient.localized)
                                .foregroundColor(colorForIngredient(trimmedIngredient))
                        }
                    }
                }

                Divider()

                // ✅ Пищевая ценность
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

                // ✅ Дата сканирования
                Text("\("scanned_on".localized): \(formatDate(product.scannedDate))")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("product_details".localized)
        .navigationBarTitleDisplayMode(.inline)
    }

    // 📍 Функция определения цвета для ингредиента (анализируем до перевода!)
    func colorForIngredient(_ ingredient: String) -> Color {
        let lowercasedIngredient = ingredient.lowercased()
        
        // Проверяем по оригинальным спискам плохих и хороших ингредиентов
        if badIngredients.contains(where: { lowercasedIngredient.contains($0) }) {
            return .red
        } else if goodIngredients.contains(where: { lowercasedIngredient.contains($0) }) {
            return .green
        } else {
            return .primary
        }
    }

    // 📆 Форматирование даты
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
