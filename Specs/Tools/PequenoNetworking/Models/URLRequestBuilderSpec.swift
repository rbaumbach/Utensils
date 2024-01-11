import Quick
import Moocher
import Capsule
@testable import Utensils

final class URLRequestBuilderSpec: QuickSpec {
    override class func spec() {
        describe("URLRequestBuilder") {
            var subject: URLRequestBuilder!
            var fakeJSONSerializationWrapper: FakeJSONSerializationWrapper!
            
            beforeEach {
                fakeJSONSerializationWrapper = FakeJSONSerializationWrapper()
                
                subject = URLRequestBuilder(jsonSerializationWrapper: fakeJSONSerializationWrapper)
            }
            
            describe("#build(baseURL:headers:urlRequestInfo:completionHandler:") {
                describe("when baseURL is malformed") {
                    it("returns an urlRequestError result") {
                        // Note: I'm unable to figure out how to make URL(string:) return nil
                    }
                }
                
                describe("when the url components url is malformed") {
                    it("returns an urlRequestError result") {
                        // Note: I'm unable to figure out how to make URLComponents.url return nil
                    }
                }
                
                describe("when everything is good") {
                    var urlRequest: URLRequest!

                    beforeEach {
                        let urlRequestInfo = URLRequestInfo(baseURL: "https://cinemassacre.com",
                                                            headers: ["version": "99.9"],
                                                            httpMethod: .get,
                                                            endpoint: "/avgn",
                                                            parameters: ["episode":"1"],
                                                            body: ["console": "nintendo"])
                        
                        let result = subject.build(urlRequestInfo: urlRequestInfo)
                        urlRequest = try! result.get()
                    }
                    
                    it("builds the URLRequest properly") {
                        expect(urlRequest.url).to.equal(URL(string: "https://cinemassacre.com/avgn?episode=1"))
                        expect(urlRequest.httpMethod).to.equal("GET")
                        expect(urlRequest.allHTTPHeaderFields).to.equal(["version": "99.9"])
                                                
                        expect(urlRequest.httpBody).to.equal(fakeJSONSerializationWrapper.stubbedJSONData)
                    }
                }
            }
        }
    }
}
