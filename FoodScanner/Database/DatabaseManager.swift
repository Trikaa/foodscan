import SQLite
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let db: Connection
    private let products = Table("products")
    
    private let id = Expression<Int64>("id")
    private let productName = Expression<String>("productName")
    private let brand = Expression<String>("brand")
    private let nutriScore = Expression<String>("nutriScore")
    private let scanDate = Expression<Date>("scanDate")
    
    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/products.sqlite3")
            createTable()
        } catch {
            fatalError("Unable to initialize database: \(error)")
        }
    }
    
    private func createTable() {
        do {
            try db.run(products.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(productName)
                t.column(brand)
                t.column(nutriScore)
                t.column(scanDate)
            })
        } catch {
            print("Unable to create table: \(error)")
        }
    }
    
    func insertProduct(productName: String, brand: String, nutriScore: String, scanDate: Date = Date()) {
        do {
            let insert = products.insert(
                self.productName <- productName,
                self.brand <- brand,
                self.nutriScore <- nutriScore,
                self.scanDate <- scanDate
            )
            try db.run(insert)
        } catch {
            print("Insert failed: \(error)")
        }
    }
    
    func fetchProducts() -> [(String, String, String, Date)] {
        var productList = [(String, String, String, Date)]()
        do {
            for product in try db.prepare(products) {
                productList.append((
                    product[productName],
                    product[brand],
                    product[nutriScore],
                    product[scanDate]
                ))
            }
        } catch {
            print("Select failed: \(error)")
        }
        return productList
    }
}
