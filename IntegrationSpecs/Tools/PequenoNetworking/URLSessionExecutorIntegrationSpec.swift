import Quick
import Moocher
import Capsule
@testable import Utensils

final class URLSessionExecutorIntegrationSpec: QuickSpec {
    override class func spec() {
        describe("PequenoNetworking") {
            var subject: URLSessionExecutor!
            
            var urlRequest: URLRequest!
                        
            beforeEach {
                subject = URLSessionExecutor()
            }
            
            describe("executing data tasks") {
                
            }
            
            describe("executing download tasks") {
                beforeEach {
                    var urlComponents = URLComponents(string: "https://httpbin.org")!
                    urlComponents.path = "/image/jpeg"
                    
                    urlRequest = URLRequest(url: urlComponents.url!)
                }
                
                it("completes with url to cached image") {
                    hangOn(for: .seconds(5)) { complete in
                        subject.executeDownload(urlRequest: urlRequest,
                                                customFilename: "animal.jpeg",
                                                directory: Directory(.caches(additionalPath: "session-downloadz/"))) { url, error in
                            guard let url = url else {
                                failSpec()
                                
                                return
                            }
                            
                            guard let imageData = try? Data(contentsOf: url) else {
                                failSpec()
                                
                                return
                            }
                            
                            expect(imageData.count).to.beGreaterThan(0)
                            
                            complete()
                        }
                    }
                }
            }
        }
    }
}
