import Quick
import Moocher
import Capsule
@testable import Utensils

final class FileLoaderSpec: QuickSpec {
    override func spec() {
        describe("FileLoader") {
            var subject: FileLoader!
            
            var fakeBundle: FakeBundle!
            var fakeStringWrapper: FakeStringWrapper!
            var fakeJSONDecoder: FakeJSONDecoder!
            
            beforeEach {
                fakeBundle = FakeBundle()
                fakeStringWrapper = FakeStringWrapper()
                fakeJSONDecoder = FakeJSONDecoder()
                
                subject = FileLoader(bundle: fakeBundle,
                                     stringWrapper: fakeStringWrapper,
                                     jsonDecoder: fakeJSONDecoder)
            }
            
            describe("#json(name:fileExtension:)") {
                describe("when the json file path cannot be loaded") {
                    beforeEach {
                        fakeBundle.stubbedPath = nil
                    }
                    
                    it("throws an unable to find file error") {
                        expect({
                            let _: String? = try subject.json(name: "file",
                                                              fileExtension: "json")
                        }).to.throwError(specificError: FileLoader.Error.unableToFindFile)
                    }
                }
                
                describe("when the json data cannot be loaded from file") {
                    beforeEach {
                        fakeStringWrapper.shouldThrowErrorLoadingData = true
                    }
                    
                    it("throws an unable to load JSON data error (with wrapped error)") {
                        expect({
                            let _: String? = try subject.json(name: "file",
                                                              fileExtension: "json")
                        }).to.throwError { error in
                            let fileLoaderError = error as! FileLoader.Error
                            
                            switch fileLoaderError {
                            case .unableToLoadJSONData(let error):
                                expect(error).toNot.beNil()
                            default:
                                failSpec()
                            }
                        }
                    }
                }
                
                describe("when the jsonData loaded from file is nil (empty file)") {
                    var decodedJSON: String!
                    
                    beforeEach {
                        fakeStringWrapper.stubbedLoadData = nil
                            
                        decodedJSON = try! subject.json(name: "file",
                                                        fileExtension: "json")
                    }
                    
                    it("returns nil without error") {
                        expect(fakeStringWrapper.capturedLoadDataPath).to.equal(fakeBundle.stubbedPath)
                        expect(fakeBundle.capturedPathForResource).to.equal("file")
                        expect(fakeBundle.capturedPathOfType).to.equal("json")
                        
                        expect(decodedJSON).to.beNil()
                    }
                }
                
                describe("when the json data cannot be decoded") {
                    beforeEach {
                        fakeJSONDecoder.shouldThrowDecodeException = true
                    }
                    
                    it("throws an unable to decode JSON data error (with wrapped error)") {
                        expect({
                            let _: String? = try subject.json(name: "file",
                                                              fileExtension: "json")
                        }).to.throwError { error in
                            let fileLoaderError = error as! FileLoader.Error
                            
                            switch fileLoaderError {
                            case .unableToDecodeJSONData(let error):
                                expect(error).toNot.beNil()
                            default:
                                failSpec()
                            }
                        }
                    }
                }
                
                describe("when everything is great...") {
                    var decodedJSON: String!
                    
                    beforeEach {
                        fakeJSONDecoder.stubbedDecodedJSON = "wooooo whooooooooo!"
                        
                        decodedJSON = try! subject.json(name: "file",
                                                        fileExtension: "json")
                    }
                    
                    it("returns events") {
                        expect(fakeBundle.capturedPathForResource).to.equal("file")
                        expect(fakeBundle.capturedPathOfType).to.equal("json")
                        expect(fakeStringWrapper.capturedLoadDataPath).to.equal(fakeBundle.stubbedPath)
                        expect(fakeJSONDecoder.capturedDecodeData).to.equal(fakeStringWrapper.stubbedLoadData)
                        
                        
                        expect(decodedJSON).to.equal("wooooo whooooooooo!")
                    }
                }
            }
        }
    }
}
