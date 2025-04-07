import SwiftUI
import CodeScanner

struct ScanView: View {
    @State private var isShowingScanner = false
    @State private var scannedProduct: ProductDetailsModel?
    @State private var isShowingDetails = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Scan a product to get started!")
                    .foregroundColor(.gray)
                    .padding()
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button("Scan Barcode") {
                    isShowingScanner = true
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("Scan Product")
            .sheet(isPresented: $isShowingScanner) {
                CustomScannerView { scannedCode in
                    handleScanResult(scannedCode)
                }
            }
            .sheet(isPresented: $isShowingDetails) {
                if let product = scannedProduct {
                    ProductDetailsView(product: product)
                }
            }
        }
    }
    
    func handleScanResult(_ code: String) {
        fetchProductInfo(for: code)
    }
    
    func fetchProductInfo(for barcode: String) {
        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received."
                }
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(OpenFoodFactsResponse.self, from: data)
                DispatchQueue.main.async {
                    guard let productData = decodedResponse.product else {
                        self.errorMessage = "No product found."
                        return
                    }
                    
                    let product = ProductDetailsModel(
                        productName: productData.product_name ?? "Unknown Product",
                        brand: productData.brands ?? "Unknown Brand",
                        nutriScore: productData.nutriscore_grade ?? "C",
                        ingredients: productData.ingredients_text?.components(separatedBy: ",") ?? [],
                        energy: Int(productData.nutriments.energyKcal ?? 0),
                        proteins: productData.nutriments.proteins ?? 0,
                        fats: productData.nutriments.fat ?? 0,
                        carbohydrates: productData.nutriments.carbohydrates ?? 0,
                        sugars: productData.nutriments.sugars ?? 0,
                        salt: productData.nutriments.salt ?? 0,
                        novaGroup: productData.nova_group ?? 0,
                        scannedDate: Date()
                    )
                    
                    self.scannedProduct = product
                    self.isShowingDetails = true
                    self.saveToHistory(product: product)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func saveToHistory(product: ProductDetailsModel) {
        var history = loadHistory()
        history.append(product)
        
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: "history")
        }
    }
    
    func loadHistory() -> [ProductDetailsModel] {
        if let data = UserDefaults.standard.data(forKey: "history"),
           let decoded = try? JSONDecoder().decode([ProductDetailsModel].self, from: data) {
            return decoded
        }
        return []
    }
}

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
