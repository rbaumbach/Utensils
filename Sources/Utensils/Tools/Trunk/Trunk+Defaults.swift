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

// Note: These defaults are untestable via unit tests as they use real dependencies

public extension Trunk {
    @discardableResult
    func save<T: Codable>(data: T) -> Result<Void, Error> {
        return save(data: data,
                    filename: "trunk",
                    directory: Directory(.applicationSupport(additionalPath: "trunk/")))
    }
    
    func save<T: Codable>(data: T,
                          completionHandler: @escaping (Result<Void, Error>) -> Void) {
        save(data: data,
             filename: "trunk",
             directory: Directory(.applicationSupport(additionalPath: "trunk/")),
             completionHandler: completionHandler)
    }
    
    @discardableResult
    func load<T: Codable>() -> Result<T, Error> {
        return load(filename: "trunk",
                    directory: Directory(.applicationSupport(additionalPath: "trunk/")))
    }
    
    func load<T: Codable>(completionHandler: @escaping (Result<T, Error>) -> Void) {
        load(filename: "trunk",
             directory: Directory(.applicationSupport(additionalPath: "trunk/")),
             completionHandler: completionHandler)
    }
}
