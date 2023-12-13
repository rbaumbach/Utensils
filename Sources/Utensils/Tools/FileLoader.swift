//MIT License
//
//Copyright (c) 2020-2023 Ryan Baumbach <github@ryan.codes>
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

public protocol FileLoaderProtocol {
    func loadJSON<T: Codable>(name: String, fileExtension: String) throws -> T?
}

public class FileLoader {
    // MARK: - Private properties
    
    private let bundle: BundleProtocol
    private let stringWrapper: StringWrapperProtocol
    private let jsonDecoder: JSONDecoderProtocol
    
    // MARK: - Error
    
    public enum Error: Swift.Error {
        case unableToFindFile
        case unableToLoadJSONData(wrappedError: Swift.Error)
        case unableToDecodeJSONData(wrappedError: Swift.Error)
    }
    
    // MARK: - Init methods
    
    public init(bundle: BundleProtocol = Bundle.main,
                stringWrapper: StringWrapperProtocol = StringWrapper(),
                jsonDecoder: JSONDecoderProtocol = JSONDecoder()) {
        self.bundle = bundle
        self.stringWrapper = stringWrapper
        self.jsonDecoder = jsonDecoder
    }
    
    // MARK: - Public methods
    
    public func loadJSON<T: Codable>(name: String,
                                     fileExtension: String) throws -> T? {
        guard let bundlePath = bundle.path(forResource: name,
                                           ofType: fileExtension) else {
            throw Error.unableToFindFile
        }
        
        guard let jsonData = try {
            do {
                return try loadData(contentsOfFile: bundlePath,
                                    encoding: .utf8)
                
            }
        }() else { return nil }
        
        let decodedJSON = try decodeJSON(T.self,
                                         data: jsonData)
        
        return decodedJSON
    }
    
    // MARK: - Private methods
    
    private func loadData(contentsOfFile: String,
                          encoding: String.Encoding) throws -> Data? {
        do {
            let jsonData = try stringWrapper.loadData(contentsOfFile: contentsOfFile,
                                                      encoding: .utf8)
            
            return jsonData
        } catch {
            let error = Error.unableToLoadJSONData(wrappedError: error)
            
            throw error
        }
    }
    
    private func decodeJSON<T: Codable>(_ type: T.Type,
                                        data: Data) throws -> T {
        do {
            let codableJSON  = try jsonDecoder.decode(T.self,
                                                      from: data)
            
            return codableJSON
        } catch {
            let error = Error.unableToDecodeJSONData(wrappedError: error)
            
            throw error
        }
    }
}
