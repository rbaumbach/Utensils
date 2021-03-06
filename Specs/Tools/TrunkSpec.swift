import Quick
import Nimble
import Capsule
@testable import Utensils

class TrunkSpec: QuickSpec {
    override func spec() {
        describe("Trunk") {
            var subject: Trunk!

            var fakeJSONCodableWrapper: FakeJSONCodableWrapper!
            var fakeDataWrapper: FakeDataWrapper!
            var fakeFileManager: FakeFileManager!
            var fakeDispatchQueueWrapper: FakeDispatchQueueWrapper!
            var directory: Directory!

            beforeEach {
                fakeJSONCodableWrapper = FakeJSONCodableWrapper()
                fakeDataWrapper = FakeDataWrapper()
                fakeFileManager = FakeFileManager()
                fakeDispatchQueueWrapper = FakeDispatchQueueWrapper()
                
                directory = Directory(fileManager: fakeFileManager)

                subject = Trunk(jsonCodableWrapper: fakeJSONCodableWrapper,
                                dataWrapper: fakeDataWrapper,
                                dispatchQueueWrapper: fakeDispatchQueueWrapper)
            }
            
            describe("output format") {
                beforeEach {
                    subject.outputFormat = .pretty
                }
                
                it("updates the internal jsonCodableWrapper outputForrmatting internally") {
                    expect(fakeJSONCodableWrapper.capturedOutputFormat).to(equal(.pretty))
                }
            }
            
            describe("date format") {
                beforeEach {
                    subject.dateFormat = .iso8601
                }
                
                it("updates the internal jsonCodableWrapper dateFormat internally") {
                    expect(fakeJSONCodableWrapper.capturedDateFormat).to(equal(.iso8601))
                }
            }

            describe("#save(data:directory:filename:)") {
                describe("when data can NOT be encoded to data") {
                    beforeEach {
                        fakeJSONCodableWrapper.shouldThrowEncodeException = true

                        subject.save(data: [0, 1, 2, 3, 4],
                                     directory: Directory(.documents()),
                                     filename: "array-of-ints")
                    }

                    it("does nothing") {
                        let typeSafeCapturedEncodeValue = fakeJSONCodableWrapper.capturedEncodeValue as! [Int]
                        
                        expect(typeSafeCapturedEncodeValue).to(equal([0, 1, 2, 3, 4]))
                        expect(fakeDataWrapper.capturedWriteData).to(beNil())
                    }
                }

                describe("when data can be encoded to JSON") {
                    describe("when data can NOT be saved to disk") {
                        beforeEach {
                            fakeDataWrapper.shouldThrowWriteException = true
                            
                            subject.save(data: [0, 1, 2, 3, 4],
                                         directory: directory,
                                         filename: "array-of-ints")
                        }

                        it("does nothing") {
                            let typeSafeCapturedEncodeValue = fakeJSONCodableWrapper.capturedEncodeValue as! [Int]
                            
                            expect(typeSafeCapturedEncodeValue).to(equal([0, 1, 2, 3, 4]))
                            
                            let expectedURL = directory.url().appendingPathComponent("array-of-ints.json")

                            expect(fakeDataWrapper.capturedWriteURL).to(equal(expectedURL))
                        }
                    }

                    describe("when data can be saved to disk") {
                        beforeEach {
                            subject.save(data: [0, 1, 2, 3, 4],
                                         directory: directory,
                                         filename: "array-of-ints")
                        }

                        it("saves the data to disk") {
                            let typeSafeCapturedEncodeValue = fakeJSONCodableWrapper.capturedEncodeValue as! [Int]

                            expect(typeSafeCapturedEncodeValue).to(equal([0, 1, 2, 3, 4]))
                            
                            expect(fakeDataWrapper.capturedWriteData).to(equal(fakeJSONCodableWrapper.stubbedEncodeData))
                            
                            let expectedURL = directory.url().appendingPathComponent("array-of-ints.json")
                            
                            expect(fakeDataWrapper.capturedWriteURL).to(equal(expectedURL))
                        }
                    }
                }
            }
            
            describe("#save(data:directory:filename:completionHandler:)") {
                var didComplete: Bool!
                
                beforeEach {
                    didComplete = false
                    
                    subject.save(data: [0, 1, 2, 3, 4], directory: directory) {
                        didComplete = true
                    }
                    
                    fakeDispatchQueueWrapper.capturedGlobalAsyncExecutionBlock?()
                    fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                }
                
                it("saves the data to disk on a background queue") {
                    expect(fakeDispatchQueueWrapper.capturedGlobalAsyncQOS).to(equal(.background))
                    
                    let typeSafeCapturedEncodeValue = fakeJSONCodableWrapper.capturedEncodeValue as! [Int]

                    expect(typeSafeCapturedEncodeValue).to(equal([0, 1, 2, 3, 4]))
                    
                    expect(fakeDataWrapper.capturedWriteData).to(equal(fakeJSONCodableWrapper.stubbedEncodeData))
                    
                    let expectedURL = directory.url().appendingPathComponent("trunk.json")
                    
                    expect(fakeDataWrapper.capturedWriteURL).to(equal(expectedURL))
                }
                
                it("executes the completion handler on the main queue") {
                    expect(didComplete).to(beTruthy())
                }
            }

            describe("#load(directory:filename:)") {
                var modelData: [Int]!
                
                describe("when the data can NOT be loaded from disk") {
                    beforeEach {
                        fakeDataWrapper.shouldThrowLoadDataException = true
                        
                        modelData = subject.load(directory: directory,
                                                 filename: "array-of-ints")
                    }
                    
                    it("returns nil") {
                        let expectedURL = directory.url().appendingPathComponent("array-of-ints.json")
                        
                        expect(fakeDataWrapper.capturedLoadDataURL).to(equal(expectedURL))

                        expect(fakeJSONCodableWrapper.capturedDecodeData).to(beNil())
                        expect(modelData).to(beNil())
                    }
                }
                
                describe("when the data can be loaded from disk") {
                    beforeEach {
                        fakeJSONCodableWrapper.stubbedDecodedData = [0, 1, 2, 3, 4]
                    }
                    
                    describe("when the data can NOT be decoded to it's appropriate model") {
                        beforeEach {
                            fakeJSONCodableWrapper.shouldThrowDecodeException = true
                                                        
                            modelData = subject.load(directory: directory,
                                                     filename: "array-of-ints")
                        }
                        
                        it("returns nil") {
                            let expectedURL = directory.url().appendingPathComponent("array-of-ints.json")
                            
                            expect(fakeDataWrapper.capturedLoadDataURL).to(equal(expectedURL))
                            
                            expect(fakeJSONCodableWrapper.capturedDecodeTypeAsString).to(equal("Array<Int>.Type"))
                            expect(fakeJSONCodableWrapper.capturedDecodeData).to(equal(fakeDataWrapper.stubbedLoadData))
                            
                            expect(modelData).to(beNil())
                        }
                    }
                    
                    describe("when the data can be decoded to it's appropriate model") {
                        beforeEach {
                            modelData = subject.load(directory: directory,
                                                     filename: "array-of-ints")
                        }
                        
                        it("returns the model data that was retrieved from disk") {
                            let expectedURL = directory.url().appendingPathComponent("array-of-ints.json")
                            
                            expect(fakeDataWrapper.capturedLoadDataURL).to(equal(expectedURL))
                            
                            expect(fakeJSONCodableWrapper.capturedDecodeTypeAsString).to(equal("Array<Int>.Type"))
                            expect(fakeJSONCodableWrapper.capturedDecodeData).to(equal(fakeDataWrapper.stubbedLoadData))
                            
                            expect(modelData).to(equal([0, 1, 2, 3, 4]))
                        }
                    }
                }
            }
            
            describe("#load(directory:filename:completionHandler:)") {
                var capturedModelData: [Int]!
                
                beforeEach {
                    fakeJSONCodableWrapper.stubbedDecodedData = [0, 1, 2, 3, 4]
                    
                    subject.load(directory: directory) { modelData in
                        capturedModelData = modelData
                    }
                    
                    fakeDispatchQueueWrapper.capturedGlobalAsyncExecutionBlock?()
                    fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                }
                
                it("returns the model data that was retrieved from disk on a background queue") {
                    expect(fakeDispatchQueueWrapper.capturedGlobalAsyncQOS).to(equal(.background))

                    let expectedURL = directory.url().appendingPathComponent("trunk.json")
                    
                    expect(fakeDataWrapper.capturedLoadDataURL).to(equal(expectedURL))
                    
                    expect(fakeJSONCodableWrapper.capturedDecodeTypeAsString).to(equal("Array<Int>.Type"))
                    expect(fakeJSONCodableWrapper.capturedDecodeData).to(equal(fakeDataWrapper.stubbedLoadData))
                }
                
                it("executes the completion handler with model data on the main queue") {
                    
                    expect(capturedModelData).to(equal([0, 1, 2, 3, 4]))
                }
            }
        }
    }
}
