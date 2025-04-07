import SwiftUI
import CodeScanner

struct ScanView: View {
    @State private var isShowingScanner = false
    @State private var scannedProduct: ProductDetailsModel?
    @State private var isShowingDetails = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView("loading_product_details".localized)
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Text("scan_product_start".localized)
                        .foregroundColor(.gray)
                        .padding()
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("scan_barcode".localized) {
                        isShowingScanner = true
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .navigationTitle("scan_product_title".localized)
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
        errorMessage = ""
        isLoading = true
        
        SmartParallelFetcher.shared.fetchProduct(barcode: code) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let (product, sources)):
                    var mergedProduct = product
                    mergedProduct.source = sources.map { $0.rawValue }.joined(separator: ", ") // ✅ Список всех баз
                    self.scannedProduct = mergedProduct
                    self.isShowingDetails = true
                    self.saveToHistory(product: mergedProduct)
                case .failure:
                    self.errorMessage = "no_product_found".localized
                }
            }
        }
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
