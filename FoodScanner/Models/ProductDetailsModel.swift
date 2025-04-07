import Foundation

struct ProductDetailsModel: Codable, Identifiable {
    var id = UUID()
    let productName: String
    let brand: String
    let nutriScore: String
    let ingredients: [String]
    let energy: Int
    let proteins: Double
    let fats: Double
    let carbohydrates: Double
    let sugars: Double
    let salt: Double
    let novaGroup: Int
    let scannedDate: Date
}
