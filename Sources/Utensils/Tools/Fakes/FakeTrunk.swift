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
    public var capturedSaveDirectory: Directory?
    public var capturedSaveFilename: String?
    
    public var capturedSaveDataAsync: Any?
    public var capturedSaveDirectoryAsync: Directory?
    public var capturedSaveFilenameAsync: String?
    public var capturedSaveCompletionHandler: ((Result<Void, Error>) -> Void)?
    
    public var capturedLoadDirectory: Directory?
    public var capturedLoadFilename: String?
    
    public var capturedLoadDirectoryAsync: Directory?
    public var capturedLoadFilenameAsync: String?
    public var capturedLoadCompletionHandler: Any?
    
    // MARK: - Stubbed properties
    
    public var stubbedOutputFormat = Trunk.OutputFormat.default
    public var stubbedDateFormat = Trunk.DateFormat.default
    
    public var stubbedSaveResult: Result<Void, Error> = .success(())
    public var stubbedSaveCompletionHandlerResult: Result<Void, Error> = .success(())
    
    public var stubbedLoadResult: Result<Any, Error> = .success("Éxito")
    public var stubbedLoadCompletionHandlerResult: Result<Any, Error> = .success("Éxito")
    
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
                                 directory: Directory,
                                 filename: String) -> Result<Void, Error> {
        capturedSaveData = data
        capturedSaveDirectory = directory
        capturedSaveFilename = filename
        
        return stubbedSaveResult
    }
    
    public func save<T: Codable>(data: T,
                                 directory: Directory,
                                 filename: String,
                                 completionHandler: @escaping (Result<Void, Error>) -> Void) {
        capturedSaveDataAsync = data
        capturedSaveDirectoryAsync = directory
        capturedSaveFilenameAsync = filename
        capturedSaveCompletionHandler = completionHandler
        
        if shouldExecuteCompletionHandlersImmediately {
            completionHandler(stubbedSaveCompletionHandlerResult)
        }
    }
    
    @discardableResult
    public func load<T: Codable>(directory: Directory,
                                 filename: String) -> Result<T, Error> {
        capturedLoadDirectory = directory
        capturedLoadFilename = filename
        
        let typedResult = stubbedLoadResult.map { value in
            guard let typedValue = value as? T else {
                preconditionFailure("The stubbed load result value is not the correct type")
            }
            
            return typedValue
        }
                
        return typedResult
    }
    
    public func load<T: Codable>(directory: Directory, 
                                 filename: String,
                                 completionHandler: @escaping (Result<T, Error>) -> Void) {
        capturedLoadDirectoryAsync = directory
        capturedLoadFilenameAsync = filename
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
}
