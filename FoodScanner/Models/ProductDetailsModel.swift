import Foundation

struct ProductDetailsModel: Codable, Identifiable {
    var id = UUID()
    var productName: String
    var brand: String
    var nutriScore: String
    var ingredients: [String]
    var energy: Int
    var proteins: Double
    var fats: Double
    var carbohydrates: Double
    var sugars: Double
    var salt: Double
    var novaGroup: Int
    var scannedDate: Date
    var source: String
}
