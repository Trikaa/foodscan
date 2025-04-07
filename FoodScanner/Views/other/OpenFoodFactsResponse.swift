import Foundation

struct OpenFoodFactsResponse: Codable {
    let product: ProductData?
}

struct ProductData: Codable {
    let product_name: String?
    let brands: String?
    let nutriscore_grade: String?
    let ingredients_text: String?
    let nova_group: Int?
    let nutriments: Nutriments
}

struct Nutriments: Codable {
    let energyKcal: Double?
    let proteins: Double?
    let fat: Double?
    let carbohydrates: Double?
    let sugars: Double?
    let salt: Double?
}
