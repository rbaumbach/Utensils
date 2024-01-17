import Quick
import Moocher
import Capsule
@testable import Utensils

final class MultipartFormDataBuilderSpec: QuickSpec {
    override class func spec() {
        describe("MultipartFormDataBuilder") {
            var subject: MultipartFormDataBuilder!
            var fakeDataWrapper: FakeDataWrapper!
            var url: URL!
            
            beforeEach {
                fakeDataWrapper = FakeDataWrapper()
                
                subject = MultipartFormDataBuilder(dataWrapper: fakeDataWrapper)
                
                url = URL(string: "file:///fake-directory/hola.txt")!
            }
            
            describe("#buildMultipartFormData(fileLocationURL:boundaryUUID:contentType:) - Result type return") {
                var actualResult: Result<Data, Error>!
                
                describe("when data wrapper throws error") {
                    beforeEach {
                        fakeDataWrapper.shouldThrowLoadDataException = true
                        
                        actualResult = subject.buildMultipartFormData(fileLocationURL: url,
                                                                      boundaryUUID: "1",
                                                                      contentType: .octetStream)
                    }
                    
                    it("returns error result") {
                        if case .failure(let error) = actualResult {
                            expect(error as? FakeGenericError).to.equal(FakeGenericError.whoCares)
                        } else { failSpec() }
                    }
                }
                
                describe("when the data can be loaded from disk") {
                    beforeEach {
                        actualResult = subject.buildMultipartFormData(fileLocationURL: url,
                                                                      boundaryUUID: "1",
                                                                      contentType: .octetStream)
                    }
                    
                    it("returns approriate data") {
                        if case .success(let data) = actualResult {
                            let expectedData = expectedMultipartFormData(data: fakeDataWrapper.stubbedLoadData)
                            
                            expect(data).to.equal(expectedData)
                        } else { failSpec() }
                    }
                }
            }
            
            describe("#buildMultipartFormData(fileLocationURL:boundaryUUID:contentType:)") {
                var actualData: Data!
                
                describe("when data wrapper throws error") {
                    beforeEach {
                        fakeDataWrapper.shouldThrowLoadDataException = true
                    }
                    
                    it("returns error result") {
                        expect {
                            actualData = try subject.buildMultipartFormData(fileLocationURL: url,
                                                                            boundaryUUID: "1",
                                                                            contentType: .octetStream)
                        }.to.throwError()
                    }
                }
                
                describe("when the data can be loaded from disk") {
                    beforeEach {
                        actualData = try! subject.buildMultipartFormData(fileLocationURL: url,
                                                                         boundaryUUID: "1",
                                                                         contentType: .octetStream)
                    }
                    
                    it("returns approriate data") {
                        let expectedData = expectedMultipartFormData(data: fakeDataWrapper.stubbedLoadData)
                        
                        expect(actualData).to.equal(expectedData)
                    }
                }
            }
            
            describe("#buildMultipartFormData(data:filename:oundaryUUID:contentType:)") {
                var actualData: Data!
                
                beforeEach {
                    actualData = subject.buildMultipartFormData(data: fakeDataWrapper.stubbedLoadData,
                                                                filename: "hola.txt",
                                                                boundaryUUID: "1",
                                                                contentType: .octetStream)
                }
                    
                it("returns approriate data") {
                    let expectedData = expectedMultipartFormData(data: fakeDataWrapper.stubbedLoadData)
                    
                    expect(actualData).to.equal(expectedData)
                }
            }
        }
    }
}

func expectedMultipartFormData(data: Data) -> Data {
    let fullBoundaryString = "Boundary-1"
    
    var multipartFormData = Data()
            
    multipartFormData.append("--\(fullBoundaryString)\r\n".data(using: .utf8)!)
    multipartFormData.append("Content-Disposition: form-data; name=\"file\"; filename=\"hola.txt\"\r\n".data(using: .utf8)!)
    multipartFormData.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
    multipartFormData.append(data)
    multipartFormData.append("\r\n".data(using: .utf8)!)
    multipartFormData.append("--\(fullBoundaryString)--\r\n".data(using: .utf8)!)
    
    return multipartFormData
}
