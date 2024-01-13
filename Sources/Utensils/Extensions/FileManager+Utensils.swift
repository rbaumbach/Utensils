//MIT License
//
//Copyright (c) 2020-2024 Ryan Baumbach <github@ryan.codes>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import Foundation
import Capsule

// Note: These are some convenience FileManager methods that chain a few of the methods together
// to handle scenarios a bit quicker without throwing errors.

// ex: The moveItem() method will throw an error if a file already exists in the destination
// location. This migrateFile() method deletes the file if it already exists and then
// moves the file.

public protocol FileManagerUtensilsProtocol: FileManagerProtocol {
    func migrateFile(at srcURL: URL, to dstURL: URL) throws
    func createDirectory(url: URL) throws
    func deleteFile(url: URL) throws
    func deleteDirectoryAndItsContents(url: URL) throws
}

extension FileManager: FileManagerUtensilsProtocol {
    public func migrateFile(at srcURL: URL, to dstURL: URL) throws {
        if fileExists(atPath: dstURL.path) {
            try removeItem(at: dstURL)
        }
        
        try moveItem(at: srcURL, to: dstURL)
    }
    
    public func createDirectory(url: URL) throws {
        if !fileExists(atPath: url.path) {
            try createDirectory(at: url,
                                withIntermediateDirectories: true,
                                attributes: nil)
        }
    }
    
    public func deleteFile(url: URL) throws {
        if fileExists(atPath: url.path) {
            try removeItem(at: url)
        }
    }
    
    public func deleteDirectoryAndItsContents(url: URL) throws {
        let directoryContents = try contentsOfDirectory(at: url,
                                                        includingPropertiesForKeys: nil)
        
        try directoryContents.forEach { url in
            try removeItem(at: url)
        }
        
        try removeItem(at: url)
    }
}

public extension FileManager.SearchPathDirectory {
    var name: String {
        switch self {
        case .applicationDirectory:
            return "application"
        case .demoApplicationDirectory:
            return "demo application"
        case .developerApplicationDirectory:
            return "developer application"
        case .adminApplicationDirectory:
            return "admin application"
        case .libraryDirectory:
            return "library"
        case .developerDirectory:
            return "developer"
        case .userDirectory:
            return "user"
        case .documentationDirectory:
            return "documentation"
        case .documentDirectory:
            return "document"
        case .coreServiceDirectory:
            return "core service"
        case .autosavedInformationDirectory:
            return "autosaved innformation"
        case .desktopDirectory:
            return "desktop"
        case .cachesDirectory:
            return "caches"
        case .applicationSupportDirectory:
            return "application support"
        case .downloadsDirectory:
            return "downloads"
        case .inputMethodsDirectory:
            return "input methods"
        case .moviesDirectory:
            return "movies"
        case .musicDirectory:
            return "music"
        case .picturesDirectory:
            return "pictures"
        case .printerDescriptionDirectory:
            return "printer description"
        case .sharedPublicDirectory:
            return "shared public"
        case .preferencePanesDirectory:
            return "preference panes"
        case .itemReplacementDirectory:
            return "item replacement"
        case .allApplicationsDirectory:
            return "all applications"
        case .allLibrariesDirectory:
            return "all libraries"
        case .trashDirectory:
            return "trash"
        @unknown default:
            return "Unknown"
        }
    }
}
