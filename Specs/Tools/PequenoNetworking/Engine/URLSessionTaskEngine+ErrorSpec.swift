import Quick
import Moocher
import Capsule
@testable import Utensils

final class URLSessionTaskEngine_ErrorSpec: QuickSpec {
    override class func spec() {
        describe("URLSessionTaskEngine+Error") {
            describe("<CaseIterable>)") {
                it("has all required cases") {
                    let expectedCases: [URLSessionTaskEngine.Error<Int>] = [.invalidSessionResponse,
                                                                            .invalidStatusCode(statusCode: 0),
                                                                            .invalidSessionItem(type: Int.self)]
                    
                    expect(URLSessionTaskEngine.Error<Int>.allCases).to.equal(expectedCases)
                }
            }
            
            describe("<Error>") {
                describe("#localizedDescription") {
                    it("has proper localized description") {
                        let invalidSessionResponse: URLSessionTaskEngine.Error<Int> = .invalidSessionResponse
                                                    
                        expect(invalidSessionResponse.localizedDescription).to.equal("Invalid URLSession task response")
                        
                        let invalidStatusCode: URLSessionTaskEngine.Error<Int> = .invalidStatusCode(statusCode: 1)
                        
                        expect(invalidStatusCode.localizedDescription).to.equal("Invalid status code: 1")
                        
                        let invalidSessionItem: URLSessionTaskEngine.Error<Int> = .invalidSessionItem(type: Int.self)
                        
                        expect(invalidSessionItem.localizedDescription).to.equal("Invalid URLSession task item of type: Int")
                    }
                }
            }
            
            describe("<LocalizedError>") {
                describe("#errorDescription") {
                    it("has proper error description") {
                        let invalidSessionResponse: URLSessionTaskEngine.Error<Int> = .invalidSessionResponse
                                                    
                        expect(invalidSessionResponse.errorDescription).to.equal("Invalid URLSession task response")
                        
                        let invalidStatusCode: URLSessionTaskEngine.Error<Int> = .invalidStatusCode(statusCode: 1)
                        
                        expect(invalidStatusCode.errorDescription).to.equal("200 - 299 are valid status codes")
                        
                        let invalidSessionItem: URLSessionTaskEngine.Error<Int> = .invalidSessionItem(type: Int.self)
                        
                        expect(invalidSessionItem.errorDescription).to.equal("Invalid URLSession task item of type: Int")
                    }
                }
                
                describe("#failureReason") {
                    it("has proper failure reason") {
                        let invalidSessionResponse: URLSessionTaskEngine.Error<Int> = .invalidSessionResponse
                                                    
                        expect(invalidSessionResponse.failureReason).to.equal("HTTPURLResponse returned by URLSession task is nil")
                        
                        let invalidStatusCode: URLSessionTaskEngine.Error<Int> = .invalidStatusCode(statusCode: 1)
                        
                        expect(invalidStatusCode.failureReason).to.equal("Invalid status code: 1")
                        
                        let invalidSessionItem: URLSessionTaskEngine.Error<Int> = .invalidSessionItem(type: Int.self)
                        
                        expect(invalidSessionItem.failureReason).to.equal("Item returned by URLSession task of type Int is nil")
                    }
                }
                
                describe("#recoverySuggestion") {
                    it("has proper recovery suggestion") {
                        let invalidSessionResponse: URLSessionTaskEngine.Error<Int> = .invalidSessionResponse
                                                    
                        expect(invalidSessionResponse.recoverySuggestion).to.equal("Invalid URLSession task response")
                        
                        let invalidStatusCode: URLSessionTaskEngine.Error<Int> = .invalidStatusCode(statusCode: 1)
                        let expectedInvalidStatusCode = "Verify your URLSession task is built appropriately as required by your API"
                        
                        expect(invalidStatusCode.recoverySuggestion).to.equal(expectedInvalidStatusCode)
                        
                        let invalidSessionItem: URLSessionTaskEngine.Error<Int> = .invalidSessionItem(type: Int.self)
                        
                        expect(invalidSessionItem.recoverySuggestion).to.equal("Invalid URLSession task item of type: Int")
                    }
                }
            }
            
            describe("<Equatable") {
                it("is equatable") {
                    let invalidSessionResponse: URLSessionTaskEngine.Error<Int> = .invalidSessionResponse
                    
                    expect(invalidSessionResponse).to.equal(.invalidSessionResponse)
                    
                    let invalidStatusCode: URLSessionTaskEngine.Error<Int> = .invalidStatusCode(statusCode: 99)
                    
                    expect(invalidSessionResponse).toNot.equal(invalidStatusCode)
                }
            }
        }
    }
}
            
