import Foundation

class IngredientStatusService {
    static let shared = IngredientStatusService()
    
    private init() {}
    
    func fetchIngredientStatus(for ingredients: [String], completion: @escaping ([String: IngredientStatus]) -> Void) {
        var results: [String: IngredientStatus] = [:]
        let group = DispatchGroup()
        
        for ingredient in ingredients {
            group.enter()
            
            let query = ingredient
                .lowercased()
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ingredient
            
            let urlString = "https://world.openfoodfacts.org/ingredient/\(query).json"
            
            guard let url = URL(string: urlString) else {
                group.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }
                
                guard let data = data,
                      let decoded = try? JSONDecoder().decode(IngredientResponse.self, from: data) else {
                    results[ingredient] = .unknown
                    return
                }
                
                if let vegetarian = decoded.ingredient?.vegetarian, vegetarian == "no" {
                    results[ingredient] = .bad
                } else if let vegan = decoded.ingredient?.vegan, vegan == "no" {
                    results[ingredient] = .bad
                } else {
                    results[ingredient] = .good
                }
            }.resume()
        }
        
        group.notify(queue: .main) {
            completion(results)
        }
    }
}

enum IngredientStatus {
    case good
    case bad
    case unknown
}

struct IngredientResponse: Codable {
    let ingredient: IngredientData?
}

struct IngredientData: Codable {
    let vegan: String?
    let vegetarian: String?
}
