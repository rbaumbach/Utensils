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
                var urlRequest: URLRequest!
                
                describe("when baseURL is malformed") {
                    beforeEach {
                        
                    }
                }
                
                describe("when the url components url is malformed") {
                    beforeEach {
                        
                    }
                }
                
                describe("when everything is good") {
                    beforeEach {
                        let urlRequestInfo = URLRequestInfo(baseURL: "https://cinemassacre.com",
                                                            headers: ["version": "99.9"],
                                                            httpMethod: .get,
                                                            endpoint: "/avgn",
                                                            parameters: ["episode":"1"],
                                                            body: ["console": "nintendo"])
                        
                        subject.build(urlRequestInfo: urlRequestInfo) { result in
                            urlRequest = try! result.get()
                        }
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
