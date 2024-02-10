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

open class FakeTrunk: Fake, TrunkProtocol {
    // MARK: - Captured properties
    
    public var capturedOutputFormat: Trunk.OutputFormat?
    
    public var capturedDateFormat: Trunk.DateFormat?
    
    public var capturedSaveData: Any?
    public var capturedSaveFilename: String?
    public var capturedSaveDirectory: Directory?
    
    public var capturedSaveDataAsync: Any?
    public var capturedSaveFilenameAsync: String?
    public var capturedSaveDirectoryAsync: Directory?
    public var capturedSaveCompletionHandler: ((Result<Void, Error>) -> Void)?
    
    public var capturedLoadFilename: String?
    public var capturedLoadDirectory: Directory?
    
    public var capturedLoadFilenameAsync: String?
    public var capturedLoadDirectoryAsync: Directory?
    public var capturedLoadCompletionHandler: Any?
    
    public var capturedDeleteFileFilename: String?
    public var capturedDeleteFileDirectory: Directory?
    
    public var capturedDeleteDirectoryDirectory: Directory?
    
    // MARK: - Stubbed properties
    
    public var stubbedOutputFormat = Trunk.OutputFormat.default
    public var stubbedDateFormat = Trunk.DateFormat.default
    
    public var stubbedSaveResult: Result<Void, Error> = .success(())
    public var stubbedSaveCompletionHandlerResult: Result<Void, Error> = .success(())
    
    public var stubbedLoadResult: Result<Any, Error> = .success("Éxito")
    public var stubbedLoadCompletionHandlerResult: Result<Any, Error> = .success("Éxito")
    
    public var stubbedDeleteFileResult: Result<Void, Error> = .success(())
    public var stubbedDeleteDirectoryResult: Result<Void, Error> = .success(())
    
    // MARK: - Public properties
    
    public var shouldExecuteCompletionHandlersImmediately = false
    
    // MARK: - Init methods
    
    public override init() { }
    
    // MARK: - <TrunkProtocol>
    
    public var outputFormat: Trunk.OutputFormat {
        get {
            return stubbedOutputFormat
        }
        
        set(newOutputFormat) {
            capturedOutputFormat = newOutputFormat
        }
    }
    
    public var dateFormat: Trunk.DateFormat {
        get {
            return stubbedDateFormat
        }
        
        set(newDateFormat) {
            capturedDateFormat = newDateFormat
        }
    }
    
    @discardableResult
    public func save<T: Codable>(data: T,
                                 filename: String,
                                 directory: Directory) -> Result<Void, Error> {
        capturedSaveData = data
        capturedSaveFilename = filename
        capturedSaveDirectory = directory
        
        return stubbedSaveResult
    }
    
    public func save<T: Codable>(data: T,
                                 filename: String,
                                 directory: Directory,
                                 completionHandler: @escaping @Sendable (Result<Void, Error>) -> Void) {
        capturedSaveDataAsync = data
        capturedSaveFilenameAsync = filename
        capturedSaveDirectoryAsync = directory
        capturedSaveCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedSaveCompletionHandlerResult)
        }
    }
    
    @discardableResult
    public func load<T: Codable>(filename: String,
                                 directory: Directory) -> Result<T, Error> {
        capturedLoadFilename = filename
        capturedLoadDirectory = directory
    
    let typedResult = stubbedLoadResult.map { value in
        guard let typedValue = value as? T else {
            preconditionFailure("The stubbed load result value is not the correct type")
        }
        
        return typedValue
    }
            
    return typedResult
}
    
    public func load<T: Codable>(filename: String,
                                 directory: Directory,
                                 completionHandler: @escaping @Sendable (Result<T, Error>) -> Void) {
        capturedLoadFilenameAsync = filename
        capturedLoadDirectoryAsync = directory
        capturedLoadCompletionHandler = completionHandler

        if shouldExecuteCompletionHandlersImmediately {
            let typedResult = stubbedLoadCompletionHandlerResult.map { value in
                guard let typedValue = value as? T else {
                    preconditionFailure("The stubbed load result value is not the correct type")
                }
                
                return typedValue
            }
            
            completionHandler(typedResult)
        }
    }
    
    public func delete(directory: Directory) -> Result<Void, Error> {
        capturedDeleteDirectoryDirectory = directory
        
        return stubbedDeleteDirectoryResult
    }
    
    public func delete(filename: String,
                       directory: Directory) -> Result<Void, Error> {
        capturedDeleteFileFilename = filename
        capturedDeleteFileDirectory = directory
        
        return stubbedDeleteFileResult
    }
}
