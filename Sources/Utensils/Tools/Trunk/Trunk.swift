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

// TODO: Add functionality to delete trunk files

public protocol TrunkProtocol {
    var outputFormat: Trunk.OutputFormat { get set }
    var dateFormat: Trunk.DateFormat { get set }
    
    @discardableResult
    func save<T: Codable>(data: T,
                          directory: Directory,
                          filename: String) -> Result<Void, Error>
    func save<T: Codable>(data: T,
                          directory: Directory,
                          filename: String,
                          completionHandler: @escaping (Result<Void, Error>) -> Void)
    
    @discardableResult
    func load<T: Codable>(directory: Directory,
                          filename: String) -> Result<T, Error>
    func load<T: Codable>(directory: Directory,
                          filename: String,
                          completionHandler: @escaping (Result<T, Error>) -> Void)
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
                dispatchQueueWrapper: DispatchQueueWrapperProtocol = DispatchQueueWrapper()) {
        self.jsonCodableWrapper = jsonCodableWrapper
        self.dataWrapper = dataWrapper
        self.dispatchQueueWrapper = dispatchQueueWrapper
    }
    
    // MARK: - Public methods
    
    @discardableResult
    public func save<T: Codable>(data: T,
                                 directory: Directory = Directory(.applicationSupport(additionalPath: "Trunk/")),
                                 filename: String = "trunk") -> Result<Void, Error> {
        do {
            let encodedJSONData = try jsonCodableWrapper.encode(data)
            let fullFileURL = try buildFullFileURL(directory: directory, filename: filename)
            
            try dataWrapper.write(data: encodedJSONData, toPath: fullFileURL)
            
            return Result<Void, Error>.success(())
        } catch {
            return Result<Void, Error>.failure(error)
        }
    }
    
    public func save<T: Codable>(data: T,
                                 directory: Directory = Directory(.applicationSupport(additionalPath: "Trunk/")),
                                 filename: String = "trunk",
                                 completionHandler: @escaping (Result<Void, Error>) -> Void) {
        dispatchQueueWrapper.globalAsync(qos: .background) { [weak self] in
            guard let self = self else { return }
            
            let result = self.save(data: data, directory: directory, filename: filename)
            
            self.dispatchQueueWrapper.mainAsync {
                completionHandler(result)
            }
        }
    }
    
    @discardableResult
    public func load<T: Codable>(directory: Directory = Directory(.applicationSupport(additionalPath: "Trunk/")),
                                 filename: String = "trunk") -> Result<T, Error> {
        do {
            let fullFileURL = try buildFullFileURL(directory: directory, filename: filename)
            
            let jsonData = try dataWrapper.loadData(contentsOfPath: fullFileURL)
            
            let modelData = try jsonCodableWrapper.decode(T.self, from: jsonData)
            
            return Result<T, Error>.success(modelData)
        } catch {
            return Result<T, Error>.failure(error)
        }
    }
    
    public func load<T: Codable>(directory: Directory = Directory(.applicationSupport(additionalPath: "Trunk/")),
                                 filename: String = "trunk",
                                 completionHandler: @escaping (Result<T, Error>) -> Void) {
        dispatchQueueWrapper.globalAsync(qos: .background) { [weak self] in
            guard let self = self else { return }
            
            let result: Result<T, Error> = self.load(directory: directory, filename: filename)
            
            self.dispatchQueueWrapper.mainAsync {
                completionHandler(result)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func buildFullFileURL(directory: Directory, filename: String) throws -> URL {
        let fullFilename = filename + fileExtension
        
        return try directory.url().appendingPathComponent(fullFilename)
    }
}
