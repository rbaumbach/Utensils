import Quick
import Moocher
import Capsule
@testable import Utensils

final class URLRequestBuilder_ErrorSpec: QuickSpec {
    override class func spec() {
        describe("URLRequestBuilder+Error") {
            describe("<CaseIterable>)") {
                it("has all required cases") {
                    let expectedCases: [URLRequestBuilder.Error] = [.invalidURL(urlString: String.empty),
                                                                    .invalidBody(body: [:],
                                                                                 wrappedError: EmptyError.empty)]
                    
                    expect(URLRequestBuilder.Error.allCases).to.equal(expectedCases)
                }
            }
            
            describe("<Error>") {
                describe("#localizedDescription") {
                    it("has proper localized description") {
                        let invalidURLError: URLRequestBuilder.Error = .invalidURL(urlString: "filez://file.txt")
                                                    
                        expect(invalidURLError.localizedDescription).to.equal("Invalid URL: filez://file.txt")
                        
                        let someBody: [String: Any] = ["uno": 1]
                        
                        let invalidBodyError: URLRequestBuilder.Error = .invalidBody(body: someBody,
                                                                                     wrappedError: FakeGenericError.whoCares)
                        
                        let expectedErrorDescription = "Invalid body: [\"uno\": 1], wrappedError: whoCares"
                        
                        expect(invalidBodyError.localizedDescription).to.equal(expectedErrorDescription)
                    }
                }
            }
            
            describe("<LocalizedError>") {
                describe("#errorDescription") {
                    it("is the same as the localized description") {
                        let invalidURLError: URLRequestBuilder.Error = .invalidURL(urlString: "filez://file.txt")
                                                    
                        expect(invalidURLError.errorDescription).to.equal("Invalid URL: filez://file.txt")
                        
                        let someBody: [String: Any] = ["uno": 1]
                        
                        let invalidBodyError: URLRequestBuilder.Error = .invalidBody(body: someBody,
                                                                                     wrappedError: FakeGenericError.whoCares)
                        
                        let expectedErrorDescription = "Invalid body: [\"uno\": 1], wrappedError: whoCares"
                        
                        expect(invalidBodyError.errorDescription).to.equal(expectedErrorDescription)
                    }
                }
                
                describe("#failureReason") {
                    it("has proper failure reason") {
                        let invalidURLError: URLRequestBuilder.Error = .invalidURL(urlString: "filez://file.txt")
                                                    
                        expect(invalidURLError.failureReason).to.equal("Invalid URL: filez://file.txt")
                                                
                        let invalidBodyError: URLRequestBuilder.Error = .invalidBody(body: [:],
                                                                                     wrappedError: FakeGenericError.whoCares)
                                                
                        expect(invalidBodyError.failureReason).to.equal("Body cannot be serialized")
                    }
                }
                
                describe("#recoverySuggestion") {
                    it("has proper recovery suggestion") {
                        let invalidURLError: URLRequestBuilder.Error = .invalidURL(urlString: "filez://file.txt")
                        let expectedURLErrorString = "Verify that the full URL from the URLRequestInfo object is valid"
                                                    
                        expect(invalidURLError.recoverySuggestion).to.equal(expectedURLErrorString)
                                                
                        let invalidBodyError: URLRequestBuilder.Error = .invalidBody(body: [:],
                                                                                     wrappedError: FakeGenericError.whoCares)
                        
                        let expectedBodyErrorString = "Verify that the body from the URLRequestInfo object is valid"
                                                
                        expect(invalidBodyError.recoverySuggestion).to.equal(expectedBodyErrorString)
                    }
                }
            }
            
            describe("<Equatable") {
                it("is equatable") {
                    let invalidURLError: URLRequestBuilder.Error = .invalidURL(urlString: "filez://file.txt")
                    
                    expect(invalidURLError).to.equal(.invalidURL(urlString: "filez://file.txt"))
                    
                    let someBody: [String: Any] = ["uno": 1]
                    
                    let invalidBodyError: URLRequestBuilder.Error = .invalidBody(body: someBody,
                                                                                 wrappedError: FakeGenericError.whoCares)
                    
                    expect(invalidURLError).toNot.equal(invalidBodyError)
                }
            }
        }
    }
}
            
