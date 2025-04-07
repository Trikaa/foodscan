import Foundation

class SmartParallelFetcher {
    static let shared = SmartParallelFetcher()
    
    private init() {}
    
    private let sourcesToCheck: [DatabaseSource] = [
        .openFoodFacts,
        .usdaFoodData,
        .openBeautyFacts,
        .foodRepo,
        .canadianNutrientFile
    ]
    
    func fetchProduct(barcode: String, completion: @escaping (Result<(ProductDetailsModel, [DatabaseSource]), Error>) -> Void) {
        var fetchedResults: [(ProductDetailsModel, DatabaseSource)] = []
        let dispatchGroup = DispatchGroup()
        
        for source in sourcesToCheck {
            dispatchGroup.enter()
            
            FoodDatabaseManager.shared.fetchProductInfo(barcode: barcode, from: source) { result in
                switch result {
                case .success(let data):
                    if let product = self.decodeProductData(data, source: source) {
                        fetchedResults.append((product, source))
                    }
                case .failure:
                    break
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if fetchedResults.isEmpty {
                completion(.failure(NSError(domain: "No product found in any database", code: 404)))
            } else {
                let mergedProduct = self.mergeProducts(fetchedResults.map { $0.0 })
                let usedSources = fetchedResults.map { $0.1 }
                completion(.success((mergedProduct, usedSources)))
            }
        }
    }
    
    private func decodeProductData(_ data: Data, source: DatabaseSource) -> ProductDetailsModel? {
        do {
            let decodedResponse = try JSONDecoder().decode(OpenFoodFactsResponse.self, from: data)
            guard let productData = decodedResponse.product else { return nil }
            
            return ProductDetailsModel(
                productName: productData.product_name ?? "",
                brand: productData.brands ?? "",
                nutriScore: productData.nutriscore_grade ?? "",
                ingredients: productData.ingredients_text?.components(separatedBy: ",") ?? [],
                energy: Int(productData.nutriments.energyKcal ?? 0),
                proteins: productData.nutriments.proteins ?? 0,
                fats: productData.nutriments.fat ?? 0,
                carbohydrates: productData.nutriments.carbohydrates ?? 0,
                sugars: productData.nutriments.sugars ?? 0,
                salt: productData.nutriments.salt ?? 0,
                novaGroup: productData.nova_group ?? 0,
                scannedDate: Date(),
                source: source.rawValue
            )
        } catch {
            return nil
        }
    }
    
    private func mergeProducts(_ products: [ProductDetailsModel]) -> ProductDetailsModel {
        var best = products.first!
        
        for product in products {
            if best.productName.isEmpty, !product.productName.isEmpty {
                best.productName = product.productName
            }
            if best.brand.isEmpty, !product.brand.isEmpty {
                best.brand = product.brand
            }
            if best.nutriScore.isEmpty, !product.nutriScore.isEmpty {
                best.nutriScore = product.nutriScore
            }
            if best.ingredients.isEmpty, !product.ingredients.isEmpty {
                best.ingredients = product.ingredients
            }
            if best.energy == 0, product.energy != 0 {
                best.energy = product.energy
            }
            if best.proteins == 0, product.proteins != 0 {
                best.proteins = product.proteins
            }
            if best.fats == 0, product.fats != 0 {
                best.fats = product.fats
            }
            if best.carbohydrates == 0, product.carbohydrates != 0 {
                best.carbohydrates = product.carbohydrates
            }
            if best.sugars == 0, product.sugars != 0 {
                best.sugars = product.sugars
            }
            if best.salt == 0, product.salt != 0 {
                best.salt = product.salt
            }
            if best.novaGroup == 0, product.novaGroup != 0 {
                best.novaGroup = product.novaGroup
            }
        }
        
        return best
    }
}
