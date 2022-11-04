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

public protocol Validatable {
    var isValid: Bool { get }
}

public protocol Validator {
    associatedtype Item: Validatable
    
    func isValid(_ item: Item) -> Bool
}

public class ValidatorEngine<Item: Validatable>: Validator {
    // MARK: - Init methods
    
    public init() { }
    
    // MARK: - Public methods
    
    public func isValid(_ item: Item) -> Bool {
        return item.isValid
    }
}

// MARK: - Lovely Type Erasure /s

// MARK: - AnyBuilder

public class AnyValidator<Item: Validatable>: Validator {
    // MARK: - Private properties

    private let box: AnyValidatorBase<Item>

    // MARK: - Init methods

    public init() {
        box = AnyValidatorBox(ValidatorEngine())
    }

    public init<T: Validator>(_ concrete: T) where T.Item == Item {
        box = AnyValidatorBox(concrete)
    }

    // MARK: - Public methods

    public func isValid(_ item: Item) -> Bool {
        return box.isValid(item)
    }
}

// MARK: - Private AnyBuilderBase

private class AnyValidatorBase<Item: Validatable>: Validator {
    // MARK: - Abstract methods
    
    func isValid(_ item: Item) -> Bool {
        fatalError("isValid(_:) method must be overridden")
    }
}

// MARK: - Private AnyBuilderBox

private class AnyValidatorBox<T: Validator>: AnyValidatorBase<T.Item> {
    var concrete: T

    init(_ concrete: T) {
        self.concrete = concrete
    }
    
    override func isValid(_ item: Item) -> Bool {
        return concrete.isValid(item)
    }
}
