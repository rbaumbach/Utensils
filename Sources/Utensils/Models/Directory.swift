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

public protocol DirectoryProtocol {
    func url() throws -> URL
}

public struct Directory: DirectoryProtocol, Equatable, Hashable {
    // MARK: - Public Enums
    
    // TODO: Find easy way to sanitize the SystemDirectory additionaPath String inputs
    
    public enum SystemDirectory: Equatable, Hashable {
        case documents(additionalPath: String? = nil)
        case temp(additionalPath: String? = nil)
        case library(additionalPath: String? = nil)
        case caches(additionalPath: String? = nil)
        case applicationSupport(additionalPath: String? = nil)
    }
    
    // MARK: - Private properties
    
    private let systemDirectory: SystemDirectory
    private let fileManager: FileManagerUtensilsProtocol
    
    // MARK: - Init methods
    
    public init(_ directoryEnum: SystemDirectory = .documents(),
                fileManager: FileManagerUtensilsProtocol = FileManager.default) {
        self.systemDirectory = directoryEnum
        self.fileManager = fileManager
    }
    
    // MARK: - Public methods
    
    public func url() throws -> URL {
        switch systemDirectory {
        case .documents(let additionalPath):
            return try generateSystemDirectoryPath(searchPathDirectory: .documentDirectory,
                                                   additionalPathString: additionalPath)

        case .temp(let additionalPath):
            return try generateTemporaryDirectoryPath(additionalPathString: additionalPath)
            
        case .library(let additionalPath):
            return try generateSystemDirectoryPath(searchPathDirectory: .libraryDirectory,
                                                   additionalPathString: additionalPath)
            
        case .caches(let additionalPath):
            return try generateSystemDirectoryPath(searchPathDirectory: .cachesDirectory,
                                                   additionalPathString: additionalPath)
            
        case .applicationSupport(let additionalPath):
            return try generateSystemDirectoryPath(searchPathDirectory: .applicationSupportDirectory,
                                                   additionalPathString: additionalPath)
        }
    }
    
    // MARK: - <Equatable>
    
    public static func == (lhs: Directory, rhs: Directory) -> Bool {
        return lhs.systemDirectory == rhs.systemDirectory
    }
    
    // MARK: - <Hashable>
    
    public func hash(into hasher: inout Hasher) {
        systemDirectory.hash(into: &hasher)
    }
    
    // MARK: - Private methods
    
    private func generateSystemDirectoryPath(searchPathDirectory: FileManager.SearchPathDirectory,
                                             additionalPathString: String?) throws -> URL {
        var directoryPath: URL
        
        if let additionalPathString = additionalPathString {
            directoryPath = try systemDirectory(searchPathDirectory).appendingPathComponent(additionalPathString,
                                                                                            isDirectory: true)
            
            try createDirectoryIfNoneExists(directoryPath: directoryPath)
        } else {
            directoryPath = try systemDirectory(searchPathDirectory)
        }
                
        return directoryPath
    }
    
    private func generateTemporaryDirectoryPath(additionalPathString: String?) throws -> URL {
        var directoryPath: URL
        
        if let additionalPathString = additionalPathString {
            directoryPath = fileManager.temporaryDirectory.appendingPathComponent(additionalPathString,
                                                                                  isDirectory: true)
            
            try createDirectoryIfNoneExists(directoryPath: directoryPath)
        } else {
            directoryPath = fileManager.temporaryDirectory
        }
        
        return directoryPath
    }
    
    private func systemDirectory(_ directory: FileManager.SearchPathDirectory) throws -> URL {
        guard let directoryURL = fileManager.urls(for: directory,
                                                  in: .userDomainMask).first else {
            let message = "Unable to access system directory: \(directory.name)"
            
            throw Doom.error(message)
        }
        
        return directoryURL
    }
    
    private func createDirectoryIfNoneExists(directoryPath: URL) throws {
        do {
            try fileManager.createDirectory(url: directoryPath)
        } catch {
            throw Directory.Error.unableToCreateDirectory(url: directoryPath, wrappedError: error)
        }
    }
}
