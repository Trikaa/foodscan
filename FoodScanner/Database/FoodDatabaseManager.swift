import Foundation

enum DatabaseSource: String, Codable {
    case openFoodFacts = "OpenFoodFacts"
    case usdaFoodData = "USDA FoodData Central"
    case openBeautyFacts = "Open Beauty Facts"
    case foodRepo = "FoodRepo"
    case canadianNutrientFile = "Canadian Nutrient File"
}

class FoodDatabaseManager {
    static let shared = FoodDatabaseManager()

    private init() {}

    func fetchProductInfo(barcode: String, from source: DatabaseSource, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let urlString: String

        switch source {
        case .openFoodFacts:
            urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
        
        case .usdaFoodData:
            let apiKey = "YOUR_USDA_API_KEY"
            urlString = "https://api.nal.usda.gov/fdc/v1/foods/search?query=\(barcode)&api_key=\(apiKey)"

        case .openBeautyFacts:
            urlString = "https://world.openbeautyfacts.org/api/v0/product/\(barcode).json"

        case .foodRepo:
            urlString = "https://www.foodrepo.org/api/v3/products/\(barcode)"
            // Потребуется добавить Authorization Header для FoodRepo

        case .canadianNutrientFile:
            urlString = "https://food-nutrition.canada.ca/cnf-fce/api/food/\(barcode)"
        }

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }

        var request = URLRequest(url: url)

        if source == .foodRepo {
            request.setValue("Bearer YOUR_FOODREPO_API_KEY", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 500)))
                return
            }

            completion(.success(data))
        }.resume()
    }
}
