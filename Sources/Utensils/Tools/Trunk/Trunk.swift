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

public protocol TrunkProtocol {
    var outputFormat: Trunk.OutputFormat { get set }
    var dateFormat: Trunk.DateFormat { get set }
    
    @discardableResult
    func save<T: Codable>(data: T,
                          filename: String,
                          directory: Directory) -> Result<Void, Error>
    
    func save<T: Codable>(data: T,
                          filename: String,
                          directory: Directory,
                          completionHandler: @escaping @Sendable (Result<Void, Error>) -> Void)
    
    @discardableResult
    func load<T: Codable>(filename: String,
                          directory: Directory) -> Result<T, Error>
    
    func load<T: Codable>(filename: String,
                          directory: Directory,
                          completionHandler: @escaping @Sendable (Result<T, Error>) -> Void)
    
    func delete(directory: Directory) -> Result<Void, Error>
    
    func delete(filename: String,
                directory: Directory) -> Result<Void, Error>
}

open class Trunk: TrunkProtocol {
    // MARK: - Public enums
    
    public enum OutputFormat {
        case `default`
        case pretty
    }

    public enum DateFormat {        
        case `default`
        case iso8601
    }
    
    // MARK: - Private constants
    
    private let fileExtension = ".json"
    
    // MARK: - Private properties
    
    private var jsonCodableWrapper: JSONCodableWrapperProtocol
    private let dataWrapper: DataWrapperProtocol
    private let fileManager: FileManagerUtensilsProtocol
    private let dispatchQueueWrapper: DispatchQueueWrapperProtocol
    
    // MARK: - Public properties
    
    public var outputFormat: OutputFormat {
        get {
            return OutputFormat(rawValue: jsonCodableWrapper.outputFormat)!
        }

        set(newOutputFormat) {
            jsonCodableWrapper.outputFormat = newOutputFormat.rawValue
        }
    }
    
    public var dateFormat: DateFormat {
        get {
            return DateFormat(rawValue: jsonCodableWrapper.dateFormat)!
        }
        
        set(newDateFormat) {
            jsonCodableWrapper.dateFormat = newDateFormat.rawValue
        }
    }
    
    // MARK: - Init methods
    
    public init(jsonCodableWrapper: JSONCodableWrapperProtocol = JSONCodableWrapper(),
                dataWrapper: DataWrapperProtocol = DataWrapper(),
                fileManager: FileManagerUtensilsProtocol = FileManager.default,
                dispatchQueueWrapper: DispatchQueueWrapperProtocol = DispatchQueueWrapper()) {
        self.jsonCodableWrapper = jsonCodableWrapper
        self.dataWrapper = dataWrapper
        self.dispatchQueueWrapper = dispatchQueueWrapper
        self.fileManager = fileManager
    }
    
    // MARK: - Public methods
        
    @discardableResult
    public func save<T: Codable>(data: T,
                                 filename: String,
                                 directory: Directory) -> Result<Void, Error> {
    do {
        let encodedJSONData = try jsonCodableWrapper.encode(data)
        let fullFileURL = try buildFullFileURL(filename: filename, directory: directory)
        
        try dataWrapper.write(data: encodedJSONData, toPath: fullFileURL)
        
        return Result<Void, Error>.success(())
    } catch {
        return Result<Void, Error>.failure(error)
    }
}
    
    public func save<T: Codable>(data: T,
                                 filename: String,
                                 directory: Directory,
                                 completionHandler: @escaping @Sendable (Result<Void, Error>) -> Void) {
        dispatchQueueWrapper.globalAsync(qos: .background) { [weak self] in
            guard let self = self else { return }
            
            let result = self.save(data: data, filename: filename, directory: directory)
            
            self.dispatchQueueWrapper.mainAsync {
                completionHandler(result)
            }
        }
    }
    
    @discardableResult
    public func load<T: Codable>(filename: String,
                                 directory: Directory) -> Result<T, Error> {
    do {
        let fullFileURL = try buildFullFileURL(filename: filename, directory: directory)
        
        let jsonData = try dataWrapper.loadData(contentsOfPath: fullFileURL)
        
        let modelData = try jsonCodableWrapper.decode(T.self, from: jsonData)
        
        return Result<T, Error>.success(modelData)
    } catch {
        return Result<T, Error>.failure(error)
    }
}
    
    public func load<T: Codable>(filename: String,
                                 directory: Directory,
                                 completionHandler: @escaping @Sendable (Result<T, Error>) -> Void) {
        dispatchQueueWrapper.globalAsync(qos: .background) { [weak self] in
            guard let self = self else { return }
            
            let result: Result<T, Error> = self.load(filename: filename, directory: directory)
            
            self.dispatchQueueWrapper.mainAsync {
                completionHandler(result)
            }
        }
    }
    
    @discardableResult
    public func delete(directory: Directory) -> Result<Void, Error> {
        do {
            let url = try directory.url()
            
            try fileManager.deleteDirectoryAndItsContents(url: url)
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    @discardableResult
    public func delete(filename: String,
                       directory: Directory) -> Result<Void, Error> {
        do {
            let fullFilename = filename + fileExtension
            
            let fullFileLocationURL = try directory.url().appendingPathComponent(fullFilename)
                        
            try fileManager.deleteFile(url: fullFileLocationURL)
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Private methods
    
    private func buildFullFileURL(filename: String, directory: Directory) throws -> URL {
        let fullFilename = filename + fileExtension
        
        return try directory.url().appendingPathComponent(fullFilename)
    }
}
