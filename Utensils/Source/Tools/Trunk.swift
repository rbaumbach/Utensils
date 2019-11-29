//MIT License
//
//Copyright (c) 2019 Ryan Baumbach <github@ryan.codes>
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
    func save<T: Codable>(data: T, directory: Directory, filename: String)
    func load<T: Codable>(directory: Directory, filename: String) -> T?
}

public class Trunk: TrunkProtocol {
    // MARK: - Private constants
    
    private let fileExtension = ".json"
    
    // MARK: - Private properties
    
    private let jsonCodableWrapper: JSONCodableWrapperProtocol
    private let dataWrapper: DataWrapperProtocol
    
    // MARK: - Init methods
    
    public init(jsonCodableWrapper: JSONCodableWrapperProtocol = JSONCodableWrapper(),
                dataWrapper: DataWrapperProtocol = DataWrapper()) {
        self.jsonCodableWrapper = jsonCodableWrapper
        self.dataWrapper = dataWrapper
    }
    
    // MARK: - Public methods
    
    public func save<T: Codable>(data: T, directory: Directory, filename: String) {
        guard let encodedJSONData = try? jsonCodableWrapper.encode(data) else {
            return
        }

        let fullFileURL = buildFullFileURL(directory: directory, filename: filename)

        do {
            try dataWrapper.write(data: encodedJSONData, toPath: fullFileURL)
        } catch { }
    }
    
    public func load<T: Codable>(directory: Directory, filename: String) -> T? {
        let fullFileURL = buildFullFileURL(directory: directory, filename: filename)
        
        guard let jsonData = try? dataWrapper.loadData(contentsOfPath: fullFileURL) else {
            return nil
        }

        guard let modelData = try? jsonCodableWrapper.decode(T.self, from: jsonData) else {
            return nil
        }
        
        return modelData
    }
    
    // MARK: - Private methods
    
    private func buildFullFileURL(directory: Directory, filename: String) -> URL {
        let fullFilename = filename + fileExtension
        
        return directory.url().appendingPathComponent(fullFilename)
    }
}
