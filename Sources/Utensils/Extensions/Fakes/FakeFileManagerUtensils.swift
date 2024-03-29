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

open class FakeFileManagerUtensils: FakeFileManager, FileManagerUtensilsProtocol {
    // MARK: - Captured properties
    
    public var capturedMigrateFileSRCURL: URL?
    public var capturedMigrateFileDSTURL: URL?
    
    public var capturedCreateDirectoryUtensilsURL: URL?
    
    public var capturedDeleteFileURL: URL?
    
    public var capturedDeleteDirectoryAndItsContentsURL: URL?
    
    // MARK: - Public properties
    
    public var shouldThrowMigrateFileError = false
    public var shouldThrowDeleteFileError = false
    public var shouldThrowDeleteDirectoryAndItsContents = false
    
    // MARK: - Init methods
    
    public override init() { }
    
    // MARK: - <FileManagerUtensilsProtocol>
    
    public func migrateFile(at srcURL: URL, to dstURL: URL) throws {
        capturedMigrateFileSRCURL = srcURL
        capturedMigrateFileDSTURL = dstURL
        
        if shouldThrowMigrateFileError {
            throw FakeGenericError.whoCares
        }
    }
    
    public func createDirectory(url: URL) throws {
        capturedCreateDirectoryUtensilsURL = url
        
        if shouldThrowCreateDirectoryError {
            throw FakeGenericError.whoCares
        }
    }
    
    public func deleteFile(url: URL) throws {
        capturedDeleteFileURL = url
        
        if shouldThrowDeleteFileError {
            throw FakeGenericError.whoCares
        }
    }
    
    public func deleteDirectoryAndItsContents(url: URL) throws {
        capturedDeleteDirectoryAndItsContentsURL = url
        
        if shouldThrowDeleteDirectoryAndItsContents {
            throw FakeGenericError.whoCares
        }
    }
}
