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

public class FakeTrunk: TrunkProtocol {
    // MARK: - Captured properties
    
    public var capturedOutputFormat: Trunk.OutputFormat?
    
    public var capturedDateFormat: Trunk.DateFormat?
    
    public var capturedSaveData: Any?
    public var capturedSaveDirectory: Directory?
    public var capturedSaveFilename: String?
    
    public var capturedLoadDirectory: Directory?
    public var capturedLoadFilename: String?
    
    // MARK: - Stubbed properties
    
    public var stubbedOutputFormat = Trunk.OutputFormat.default
    
    public var stubbedDateFormat = Trunk.DateFormat.default
    
    public var stubbedLoadData: Any?
    
    // MARK: - Init methods
    
    public init() { }
    
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
    
    public func save<T: Codable>(data: T, directory: Directory, filename: String) {
        capturedSaveData = data
        capturedSaveDirectory = directory
        capturedSaveFilename = filename
    }
    
    public func load<T: Codable>(directory: Directory, filename: String) -> T? {
        guard let stubbedLoadData = stubbedLoadData else {
            return nil
        }
        
        capturedLoadDirectory = directory
        capturedLoadFilename = filename
                
        return stubbedLoadData as? T
    }
}
