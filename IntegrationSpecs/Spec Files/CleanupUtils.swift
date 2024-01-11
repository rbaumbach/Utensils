import Foundation

class CleanupUtils {
    static func removeFileIfNeeded(at url: URL) {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: url.path) {
            try! fileManager.removeItem(at: url)
        }
    }
}
