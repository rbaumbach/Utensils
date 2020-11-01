//MIT License
//
//Copyright (c) 2020 Ryan Baumbach <github@ryan.codes>
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
    func url() -> URL
}

public struct Directory: Equatable, Hashable {
    // MARK: - Public Enums
    
    public enum SystemDirectory: Equatable, Hashable {
        case documents(additionalPath: String? = nil)
        case temp(additionalPath: String? = nil)
        case library(additionalPath: String? = nil)
        case caches(additionalPath: String? = nil)
        case applicationSupport(additionalPath: String? = nil)
    }
    
    // MARK: - Private properties
    
    private let systemDirectory: SystemDirectory
    private let fileManager: FileManagerProtocol
    
    // MARK: - Init methods
    
    public init(_ directoryEnum: SystemDirectory = .documents(),
                fileManager: FileManagerProtocol = FileManager.default) {
        self.systemDirectory = directoryEnum
        self.fileManager = fileManager
    }
    
    // MARK: - Public methods
    
    public func url() -> URL {
        switch systemDirectory {
        case .documents(let additionalPath):
            return generateSystemDirectoryPath(searchPathDirectory: .documentDirectory,
                                               additionalPathString: additionalPath)

        case .temp(let additionalPath):
            return generateTemporaryDirectoryPath(additionalPathString: additionalPath)
            
        case .library(let additionalPath):
            return generateSystemDirectoryPath(searchPathDirectory: .libraryDirectory,
                                               additionalPathString: additionalPath)

        case .caches(let additionalPath):
            return generateSystemDirectoryPath(searchPathDirectory: .cachesDirectory,
                                               additionalPathString: additionalPath)

        case .applicationSupport(let additionalPath):
            return generateSystemDirectoryPath(searchPathDirectory: .applicationSupportDirectory,
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
                                             additionalPathString: String?) -> URL {
        var directoryPath: URL
        
        if let additionalPathString = additionalPathString {
            directoryPath = systemDirectory(searchPathDirectory).appendingPathComponent(additionalPathString)
        } else {
            directoryPath = systemDirectory(searchPathDirectory)
        }

        createDirectoryIfNoneExists(directoryPath: directoryPath)
        
        return directoryPath
    }
    
    private func generateTemporaryDirectoryPath(additionalPathString: String?) -> URL {
        var directoryPath: URL
        
        if let additionalPathString = additionalPathString {
            directoryPath = fileManager.temporaryDirectory.appendingPathComponent(additionalPathString)
            
            createDirectoryIfNoneExists(directoryPath: directoryPath)
        } else {
            directoryPath = fileManager.temporaryDirectory
        }
        
        return directoryPath
    }
    
    private func systemDirectory(_ directory: FileManager.SearchPathDirectory) -> URL {
        guard let directoryURL = fileManager.urls(for: directory, in: .userDomainMask).first else {
            preconditionFailure("Uh oh, unable to get system directory: \(directory)")
        }

        return directoryURL
    }
        
    private func createDirectoryIfNoneExists(directoryPath: URL) {
        if !fileManager.fileExists(atPath: directoryPath.path) {
            do {
                try fileManager.createDirectory(at: directoryPath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                preconditionFailure("Uh oh, unable to create directory: \(directoryPath)")
            }
        }
    }
}
