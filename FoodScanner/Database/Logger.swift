import Foundation

class AppLogger {
    static func info(_ message: String) {
        print("ℹ️ [INFO]: \(message)")
    }

    static func warning(_ message: String) {
        print("⚠️ [WARNING]: \(message)")
    }

    static func error(_ message: String) {
        print("❌ [ERROR]: \(message)")
    }
}
