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

public protocol FileLoaderProtocol {
    func loadJSON<D: Decodable>(name: String,
                                fileExtension: String) throws -> D?
}

open class FileLoader<T: BundleProtocol,
                      U: StringWrapperProtocol,
                      V: JSONDecoderProtocol> {
    // MARK: - Private properties
    
    private let bundle: T
    private let stringWrapper: U
    private let jsonDecoder: V
    
    public init(bundle: T = Bundle.main,
                stringWrapper: U = StringWrapper(),
                jsonDecoder: V = JSONDecoder()) {
        self.bundle = bundle
        self.stringWrapper = stringWrapper
        self.jsonDecoder = jsonDecoder
    }
    
    // MARK: - Public methods
    
    public func loadJSON<D: Codable>(name: String,
                                     fileExtension: String) throws -> D? {
        guard let bundlePath = bundle.path(forResource: name,
                                           ofType: fileExtension) else {
            throw Error.unableToFindFile(fileName: "\(name).\(fileExtension)")
        }
        
        guard let jsonData = try {
            do {
                return try loadData(contentsOfFile: bundlePath,
                                    encoding: .utf8)
                
            }
        }() else { return nil }
        
        let decodedJSON = try decodeJSON(D.self,
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
    
    private func decodeJSON<D: Decodable>(_ type: D.Type,
                                          data: Data) throws -> D {
        do {
            let codableJSON  = try jsonDecoder.decode(D.self,
                                                      from: data)
            
            return codableJSON
        } catch {
            let error = Error.unableToDecodeJSONData(wrappedError: error)
            
            throw error
        }
    }
}
