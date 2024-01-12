import Quick
import Moocher
import Capsule
@testable import Utensils

final class TrunkSpec: QuickSpec {
    override class func spec() {
        describe("Trunk") {
            var subject: Trunk!

            var fakeJSONCodableWrapper: FakeJSONCodableWrapper!
            var fakeDataWrapper: FakeDataWrapper!
            var fakeFileManager: FakeFileManagerUtensils!
            var fakeDispatchQueueWrapper: FakeDispatchQueueWrapper!
            var directory: Directory!

            beforeEach {
                fakeJSONCodableWrapper = FakeJSONCodableWrapper()
                fakeDataWrapper = FakeDataWrapper()
                fakeFileManager = FakeFileManagerUtensils()
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
                    expect(fakeJSONCodableWrapper.capturedOutputFormat).to.equal(.pretty)
                }
            }
            
            describe("date format") {
                beforeEach {
                    subject.dateFormat = .iso8601
                }
                
                it("updates the internal jsonCodableWrapper dateFormat internally") {
                    expect(fakeJSONCodableWrapper.capturedDateFormat).to.equal(.iso8601)
                }
            }

            describe("#save(data:directory:filename:)") {
                var actualResult: Result<Void, Error>!
                
                describe("when data can NOT be encoded to data") {
                    beforeEach {
                        fakeJSONCodableWrapper.shouldThrowEncodeException = true

                        actualResult = subject.save(data: [0, 1, 2, 3, 4],
                                                    directory: Directory(.documents()),
                                                    filename: "array-of-ints")
                    }

                    it("returns error result") {
                        if case .failure(let error) = actualResult {
                            expect(error).toNot.beNil()
                        } else { failSpec() }
                        
                        let typeSafeCapturedEncodeValue = fakeJSONCodableWrapper.capturedEncodeValue as! [Int]
                        
                        expect(typeSafeCapturedEncodeValue).to.equal([0, 1, 2, 3, 4])
                        expect(fakeDataWrapper.capturedWriteData).to.beNil()
                    }
                }

                describe("when data can be encoded to JSON") {
                    describe("when data can NOT be saved to disk") {
                        beforeEach {
                            fakeDataWrapper.shouldThrowWriteException = true
                            
                            actualResult = subject.save(data: [0, 1, 2, 3, 4],
                                                        directory: directory,
                                                        filename: "array-of-ints")
                        }

                        it("returns error result") {
                            if case .failure(let error) = actualResult {
                                expect(error).toNot.beNil()
                            } else { failSpec() }
                            
                            let typeSafeCapturedEncodeValue = fakeJSONCodableWrapper.capturedEncodeValue as! [Int]
                            
                            expect(typeSafeCapturedEncodeValue).to.equal([0, 1, 2, 3, 4])
                            
                            let expectedURL = try! directory.url().appendingPathComponent("array-of-ints.json")

                            expect(fakeDataWrapper.capturedWriteURL).to.equal(expectedURL)
                        }
                    }

                    describe("when data can be saved to disk") {
                        beforeEach {
                            actualResult = subject.save(data: [0, 1, 2, 3, 4],
                                                        directory: directory,
                                                        filename: "array-of-ints")
                        }

                        it("saves the data to disk and returns successful result") {
                            if case .failure = actualResult {
                                failSpec()
                            }
                            
                            let typeSafeCapturedEncodeValue = fakeJSONCodableWrapper.capturedEncodeValue as! [Int]

                            expect(typeSafeCapturedEncodeValue).to.equal([0, 1, 2, 3, 4])
                            
                            expect(fakeDataWrapper.capturedWriteData).to.equal(fakeJSONCodableWrapper.stubbedEncodeData)
                            
                            let expectedURL = try! directory.url().appendingPathComponent("array-of-ints.json")
                            
                            expect(fakeDataWrapper.capturedWriteURL).to.equal(expectedURL)
                        }
                    }
                }
            }
            
            describe("#save(data:directory:filename:completionHandler:)") {
                var didComplete: Bool!
                var actualResult: Result<Void, Error>!
                
                beforeEach {
                    didComplete = false
                    
                    subject.save(data: [0, 1, 2, 3, 4], directory: directory) { result in
                        actualResult = result
                        didComplete = true
                    }
                    
                    fakeDispatchQueueWrapper.capturedGlobalAsyncExecutionBlock?()
                    fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                }
                
                it("saves the data to disk on a background queue") {
                    expect(fakeDispatchQueueWrapper.capturedGlobalAsyncQOS).to.equal(.background)
                    
                    let typeSafeCapturedEncodeValue = fakeJSONCodableWrapper.capturedEncodeValue as! [Int]

                    expect(typeSafeCapturedEncodeValue).to.equal([0, 1, 2, 3, 4])
                    
                    expect(fakeDataWrapper.capturedWriteData).to.equal(fakeJSONCodableWrapper.stubbedEncodeData)
                    
                    let expectedURL = try! directory.url().appendingPathComponent("trunk.json")
                    
                    expect(fakeDataWrapper.capturedWriteURL).to.equal(expectedURL)
                }
                
                it("completes with result (on main queue)") {
                    if case .failure = actualResult { failSpec() }
                    
                    expect(didComplete).to.beTruthy()
                }
            }

            describe("#load(directory:filename:)") {
                var modelData: [Int]!
                
                describe("when the data can NOT be loaded from disk") {
                    beforeEach {
                        fakeDataWrapper.shouldThrowLoadDataException = true
                        
                        modelData = try? subject.load(directory: directory,
                                                      filename: "array-of-ints").get()
                    }
                    
                    it("returns result with error") {
                        let expectedURL = try? directory.url().appendingPathComponent("array-of-ints.json")
                        
                        expect(fakeDataWrapper.capturedLoadDataURL).to.equal(expectedURL)

                        expect(fakeJSONCodableWrapper.capturedDecodeData).to.beNil()
                        expect(modelData).to.beNil()
                    }
                }
                
                describe("when the data can be loaded from disk") {
                    beforeEach {
                        fakeJSONCodableWrapper.stubbedDecodedData = [0, 1, 2, 3, 4]
                    }
                    
                    describe("when the data can NOT be decoded to it's appropriate model") {
                        beforeEach {
                            fakeJSONCodableWrapper.shouldThrowDecodeException = true
                            
                            modelData = try? subject.load(directory: directory,
                                                          filename: "array-of-ints").get()
                        }
                        
                        it("returns nil") {
                            let expectedURL = try? directory.url().appendingPathComponent("array-of-ints.json")
                            
                            expect(fakeDataWrapper.capturedLoadDataURL).to.equal(expectedURL)
                            
                            expect(fakeJSONCodableWrapper.capturedDecodeTypeAsString).to.contain("Array<Int>")
                            expect(fakeJSONCodableWrapper.capturedDecodeData).to.equal(fakeDataWrapper.stubbedLoadData)
                            
                            expect(modelData).to.beNil()
                        }
                    }
                    
                    describe("when the data can be decoded to it's appropriate model") {
                        beforeEach {
                            modelData = try? subject.load(directory: directory,
                                                          filename: "array-of-ints").get()
                        }
                        
                        it("returns the model data that was retrieved from disk") {
                            let expectedURL = try? directory.url().appendingPathComponent("array-of-ints.json")
                            
                            expect(fakeDataWrapper.capturedLoadDataURL).to.equal(expectedURL)
                            
                            expect(fakeJSONCodableWrapper.capturedDecodeTypeAsString).to.contain("Array<Int>")
                            expect(fakeJSONCodableWrapper.capturedDecodeData).to.equal(fakeDataWrapper.stubbedLoadData)
                            
                            expect(modelData).to.equal([0, 1, 2, 3, 4])
                        }
                    }
                }
            }
            
            describe("#load(directory:filename:completionHandler:)") {
                var actualResult: Result<[Int], Error>!
                
                beforeEach {
                    fakeJSONCodableWrapper.stubbedDecodedData = [0, 1, 2, 3, 4]
                    
                    subject.load(directory: directory) { result in
                        actualResult = result
                    }
                    
                    fakeDispatchQueueWrapper.capturedGlobalAsyncExecutionBlock?()
                    fakeDispatchQueueWrapper.capturedMainAsyncExecutionBlock?()
                }
                
                it("returns the model data that was retrieved from disk on a background queue") {
                    expect(fakeDispatchQueueWrapper.capturedGlobalAsyncQOS).to.equal(.background)

                    let expectedURL = try! directory.url().appendingPathComponent("trunk.json")
                    
                    expect(fakeDataWrapper.capturedLoadDataURL).to.equal(expectedURL)
                    
                    expect(fakeJSONCodableWrapper.capturedDecodeTypeAsString).to.contain("Array<Int>")
                    expect(fakeJSONCodableWrapper.capturedDecodeData).to.equal(fakeDataWrapper.stubbedLoadData)
                }
                
                it("completes with a result (on main queue)") {
                    if case .success(let modelData) = actualResult {
                        expect(modelData).to.equal([0, 1, 2, 3, 4])
                    } else {
                        failSpec()
                    }
                }
            }
        }
    }
}
