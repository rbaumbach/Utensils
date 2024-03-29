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

public protocol DebouncerProtocol {
    func mainDebounce(seconds: Double, execute: @escaping @Sendable () -> Void)
}

open class Debouncer: DebouncerProtocol {
    // MARK: - Private properties
    
    private let dispatchQueueWrapper: DispatchQueueWrapperProtocol
    private let dispatchWorkItemWrapperBuilder: DispatchWorkItemWrapperBuilderProtocol
    
    // MARK: - Internal readonly properties
        
    internal private(set) lazy var currentDispatchWorkItemWrapper: DispatchWorkItemWrapperProtocol = {
        let workItemWrapper = dispatchWorkItemWrapperBuilder.build(qos: .unspecified, work: { })
        
        return workItemWrapper
    }()
        
    // MARK: - Init methods
    
    public init(dispatchQueueWrapper: DispatchQueueWrapperProtocol = DispatchQueueWrapper(),
                dispatchWorkItemWrapperBuilder: DispatchWorkItemWrapperBuilderProtocol = DispatchWorkItemWrapperBuilder()) {
        self.dispatchQueueWrapper = dispatchQueueWrapper
        self.dispatchWorkItemWrapperBuilder = dispatchWorkItemWrapperBuilder
    }
    
    // MARK: - Public methods
    
    public func mainDebounce(seconds: Double = 0.1, execute: @escaping @Sendable () -> Void) {
        currentDispatchWorkItemWrapper.cancel()

        currentDispatchWorkItemWrapper = dispatchWorkItemWrapperBuilder.build(qos: .unspecified, 
                                                                              work: execute)
        
        dispatchQueueWrapper.mainAfter(seconds: seconds, dispatchWorkItemWrapper: currentDispatchWorkItemWrapper)
    }
}
