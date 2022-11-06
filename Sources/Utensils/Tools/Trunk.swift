//MIT License
//
//Copyright (c) 2020-2022 Ryan Baumbach <github@ryan.codes>
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
    
    func save<T: Codable>(data: T, directory: Directory, filename: String)
    func save<T: Codable>(data: T, directory: Directory, filename: String, completionHandler: @escaping () -> Void)
    
    func load<T: Codable>(directory: Directory, filename: String) -> T?
    func load<T: Codable>(directory: Directory, filename: String, completionHandler: @escaping (T?) -> Void)
}

public class Trunk: TrunkProtocol {
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
    
    public func save<T: Codable>(data: T,
                                 directory: Directory = Directory(.applicationSupport(additionalPath: "Trunk/")),
                                 filename: String = "trunk") {
        guard let encodedJSONData = try? jsonCodableWrapper.encode(data) else {
            return
        }

        let fullFileURL = buildFullFileURL(directory: directory, filename: filename)

        do {
            try dataWrapper.write(data: encodedJSONData, toPath: fullFileURL)
        } catch { }
    }
    
    public func save<T: Codable>(data: T,
                                 directory: Directory = Directory(.applicationSupport(additionalPath: "Trunk/")),
                                 filename: String = "trunk",
                                 completionHandler: @escaping () -> Void) {
        dispatchQueueWrapper.globalAsync(qos: .background) { [weak self] in
            self?.save(data: data, directory: directory, filename: filename)

            self?.dispatchQueueWrapper.mainAsync {
                completionHandler()
            }
        }
    }
    
    public func load<T: Codable>(directory: Directory = Directory(.applicationSupport(additionalPath: "Trunk/")),
                                 filename: String = "trunk") -> T? {
        let fullFileURL = buildFullFileURL(directory: directory, filename: filename)
        
        guard let jsonData = try? dataWrapper.loadData(contentsOfPath: fullFileURL) else {
            return nil
        }

        guard let modelData = try? jsonCodableWrapper.decode(T.self, from: jsonData) else {
            return nil
        }
        
        return modelData
    }
    
    public func load<T: Codable>(directory: Directory = Directory(.applicationSupport(additionalPath: "Trunk/")),
                                 filename: String = "trunk",
                                 completionHandler: @escaping (T?) -> Void) {
        dispatchQueueWrapper.globalAsync(qos: .background) { [weak self] in
            let modelData: T? = self?.load(directory: directory, filename: filename)
            
            self?.dispatchQueueWrapper.mainAsync {
                completionHandler(modelData)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func buildFullFileURL(directory: Directory, filename: String) -> URL {
        let fullFilename = filename + fileExtension
        
        return directory.url().appendingPathComponent(fullFilename)
    }
}
